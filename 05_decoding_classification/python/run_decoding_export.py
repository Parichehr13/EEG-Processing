#!/usr/bin/env python
"""Run Exercise 10 (Python) and export report-ready figures."""

from __future__ import annotations

import json
import random
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
from sklearn.metrics import ConfusionMatrixDisplay, confusion_matrix
from tensorflow import keras

from exercise10_utils.utils import EEGNet, load_bci_iv2a


def to_one_hot(y_dense: np.ndarray, n_classes: int) -> np.ndarray:
    n_examples = y_dense.shape[0]
    y = np.zeros((n_examples, n_classes), dtype=int)
    for i in range(n_examples):
        y[i, y_dense[i]] = 1
    return y


def save_figure(fig, out_path: Path, dpi: int = 600) -> None:
    fig.set_size_inches(14, 9, forward=True)
    fig.tight_layout()
    fig.savefig(out_path, dpi=dpi, bbox_inches="tight")
    plt.close(fig)


def main() -> None:
    random.seed(42)
    np.random.seed(42)
    keras.utils.set_random_seed(42)

    here = Path(__file__).resolve().parent
    root_ex = here.parent
    fig_dir = root_ex / "figures"
    fig_dir.mkdir(parents=True, exist_ok=True)

    # Clean previous exported Exercise 10 PNGs
    for old in fig_dir.glob("exercise10_py_fig_*.png"):
        old.unlink(missing_ok=True)

    n_chans = 22
    n_time = 256
    n_classes = 4

    (x_train, labels_train), (x_test, labels_test), srate, ch_names, conditions = load_bci_iv2a(
        str(here / "exercise10_utils" / "bci_iv2a_sub-008.mat")
    )

    n_examples_train = x_train.shape[0]
    n_examples_test = x_test.shape[0]
    x_train = x_train.reshape((n_examples_train, n_chans, n_time, 1))
    x_test = x_test.reshape((n_examples_test, n_chans, n_time, 1))

    y_train = to_one_hot(labels_train, n_classes)
    y_test = to_one_hot(labels_test, n_classes)

    valid_ratio = 0.1
    n_valid = round(valid_ratio * n_examples_train)
    x_valid = x_train[:n_valid, :, :, :]
    y_valid = y_train[:n_valid, :]
    labels_valid = labels_train[:n_valid]
    x_train = x_train[n_valid:, :, :, :]
    y_train = y_train[n_valid:, :]
    labels_train = labels_train[n_valid:]

    m = np.mean(x_train)
    s = np.std(x_train)
    x_train = (x_train - m) / (1e-15 + s)
    x_valid = (x_valid - m) / (1e-15 + s)
    x_test = (x_test - m) / (1e-15 + s)

    saved = []

    # Figure 1: class histogram per split
    fig = plt.figure(figsize=(14, 9))
    for idx, (labels, title) in enumerate(
        [(labels_train, "Training set"), (labels_valid, "Validation set"), (labels_test, "Test set")], start=1
    ):
        ax = fig.add_subplot(1, 3, idx)
        n_examples_perclass = [np.sum(labels == c) for c in np.unique(labels)]
        ax.bar(np.arange(len(conditions)), n_examples_perclass, facecolor="grey", edgecolor="k")
        ax.set_ylim([0, 80])
        ax.set_xticks(np.arange(len(conditions)), conditions, rotation=30)
        ax.set_title(title)
        ax.set_ylabel("no. of examples")
        ax.set_xlabel("class")

    out1 = fig_dir / "exercise10_py_fig_001.png"
    save_figure(fig, out1)
    saved.append(out1.name)

    # Model + training
    model = EEGNet((n_chans, n_time, 1), n_classes)
    optimizer = keras.optimizers.SGD(learning_rate=0.001, momentum=0.9)
    model.compile(loss="categorical_crossentropy", optimizer=optimizer, metrics=["accuracy"])

    ckpt_path = here / "best_mdl.keras"
    callbacks = [
        keras.callbacks.ModelCheckpoint(filepath=str(ckpt_path), monitor="val_loss", save_best_only=True),
        keras.callbacks.EarlyStopping(monitor="val_loss", patience=40, restore_best_weights=True),
    ]

    history = model.fit(
        x_train,
        y_train,
        batch_size=32,
        epochs=400,
        validation_data=(x_valid, y_valid),
        callbacks=callbacks,
        verbose=2,
    )

    train_loss = history.history["loss"]
    train_acc = history.history["accuracy"]
    valid_loss = history.history["val_loss"]
    valid_acc = history.history["val_accuracy"]
    epochs = np.arange(1, len(train_loss) + 1)

    # Figure 2: loss + accuracy curves
    fig = plt.figure(figsize=(14, 9))
    ax1 = fig.add_subplot(2, 1, 1)
    ax1.plot(epochs, train_loss, "k", label="training")
    ax1.plot(epochs, valid_loss, "r", label="validation")
    ax1.set_ylabel("loss")
    ax1.set_xlabel("epochs")
    ax1.legend()

    ax2 = fig.add_subplot(2, 1, 2)
    ax2.plot(epochs, train_acc, "k", label="training")
    ax2.plot(epochs, valid_acc, "r", label="validation")
    ax2.set_ylabel("accuracy")
    ax2.set_xlabel("epochs")
    ax2.legend()

    out2 = fig_dir / "exercise10_py_fig_002.png"
    save_figure(fig, out2)
    saved.append(out2.name)

    # Evaluation + confusion matrices
    model = keras.models.load_model(ckpt_path)

    eval_sets = [
        ("Training", x_train, labels_train),
        ("Validation", x_valid, labels_valid),
        ("Test", x_test, labels_test),
    ]
    conf_mats = []
    for name, x_set, y_true in eval_sets:
        proba = model.predict(x_set, verbose=0)
        y_pred = np.argmax(proba, axis=-1)
        cmtx = confusion_matrix(y_true=y_true, y_pred=y_pred)
        acc = float(np.mean(y_true == y_pred))
        conf_mats.append((name, cmtx))
        print("#" * 10 + f"{name} set")
        print("Confusion matrix")
        print(cmtx)
        print("Accuracy:", acc)

    fig = plt.figure(figsize=(14, 9))
    for i, (name, cmtx) in enumerate(conf_mats, start=1):
        ax = fig.add_subplot(1, 3, i)
        disp = ConfusionMatrixDisplay(confusion_matrix=cmtx, display_labels=conditions)
        disp.plot(ax=ax, colorbar=False, cmap="Blues", values_format="d")
        ax.set_title(f"{name} set")
        ax.set_xlabel("Predicted")
        ax.set_ylabel("True")
    out3 = fig_dir / "exercise10_py_fig_003.png"
    save_figure(fig, out3)
    saved.append(out3.name)

    # Figure 4: aggregated spatial filter weights
    layers = model.layers
    layer = layers[2]
    weights = layer.get_weights()[0]
    weights = weights.reshape((weights.shape[0], -1))
    weights = np.abs(weights)
    weights = np.mean(weights, axis=1)

    fig = plt.figure(figsize=(14, 9))
    ax = fig.add_subplot(1, 1, 1)
    x = np.arange(weights.shape[0])
    ax.bar(x=x, height=weights, facecolor="grey", edgecolor="k")
    ax.set_ylabel("average absolute weight")
    ax.set_xlabel("EEG channel")
    ax.set_xticks(ticks=x, labels=ch_names, rotation=45, ha="right")
    out4 = fig_dir / "exercise10_py_fig_004.png"
    save_figure(fig, out4)
    saved.append(out4.name)

    manifest_path = fig_dir / "exercise10_manifest.json"
    manifest_path.write_text(json.dumps(saved), encoding="utf-8")
    print("Saved figures:", saved)


if __name__ == "__main__":
    main()
