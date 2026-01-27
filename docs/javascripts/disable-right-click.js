// Disable right-click context menu
document.addEventListener("contextmenu", function (e) {
  e.preventDefault();
});

// Optional: block common copy shortcuts
document.addEventListener("keydown", function (e) {
  if (
    (e.ctrlKey && (e.key === "c" || e.key === "u" || e.key === "s")) || 
    (e.metaKey && (e.key === "c" || e.key === "u" || e.key === "s")) ||
    e.key === "F12"
  ) {
    e.preventDefault();
  }
});
