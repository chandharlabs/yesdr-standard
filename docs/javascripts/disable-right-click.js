// Disable right-click context menu
//document.addEventListener("contextmenu", function (e) {
//  e.preventDefault();
//});
//
// Optional: block common copy shortcuts
//document.addEventListener("keydown", function (e) {
//  if (
//    (e.ctrlKey && (e.key === "c" || e.key === "u" || e.key === "s")) || 
//    (e.metaKey && (e.key === "c" || e.key === "u" || e.key === "s")) ||
//    e.key === "F12"
//  ) {
//    e.preventDefault();
//  }
//});

document.addEventListener("click", function (e) {
  const thumb = e.target.closest(".yesdr-view");
  if (!thumb) return;

  let scale = 1;
  let x = 0, y = 0;
  let dragging = false;
  let startX = 0, startY = 0;

  // Create overlay
  const overlay = document.createElement("div");
  overlay.className = "yesdr-overlay active";
  overlay.innerHTML = `
    <span class="yesdr-close">×</span>
    <img src="${thumb.src}">
  `;
  document.body.appendChild(overlay);

  const img = overlay.querySelector("img");
  const close = overlay.querySelector(".yesdr-close");

  close.onclick = () => overlay.remove();

  /* ===== PAN ONLY WHILE HOLDING MOUSE ===== */
  img.addEventListener("mousedown", e => {
    dragging = true;
    startX = e.clientX - x;
    startY = e.clientY - y;
    img.style.cursor = "grabbing";
    e.preventDefault();
  });

  window.addEventListener("mousemove", e => {
    if (!dragging) return;
    x = e.clientX - startX;
    y = e.clientY - startY;
    img.style.transform =
      `translate(${x}px, ${y}px) scale(${scale})`;
  });

  window.addEventListener("mouseup", () => {
    if (!dragging) return;
    dragging = false;
    img.style.cursor = "grab";
  });

  /* ===== SMOOTH IMAGE ZOOM (WHEEL) ===== */
  overlay.addEventListener("wheel", e => {
    e.preventDefault();
    scale += e.deltaY * -0.0012;
    scale = Math.min(Math.max(0.7, scale), 2.5);
    img.style.transform =
      `translate(${x}px, ${y}px) scale(${scale})`;
  }, { passive: false });
});

