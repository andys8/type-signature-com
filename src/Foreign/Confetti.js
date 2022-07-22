import _confetti from "canvas-confetti";

export const confetti = _confetti;

export const schoolPride = () => {
  const end = Date.now() + 1000;
  const particleCount = 2;
  const colors = ["#ff5555", "#f8f8f2"];

  const frame = () => {
    _confetti({
      angle: 60,
      spread: 55,
      origin: { x: 0 },
      particleCount,
      colors,
    });
    _confetti({
      angle: 120,
      spread: 55,
      origin: { x: 1 },
      particleCount,
      colors,
    });

    if (Date.now() < end) {
      requestAnimationFrame(frame);
    }
  };

  frame();
};
