document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-tabs]").forEach((tabs) => {
    const buttons = Array.from(tabs.querySelectorAll("[data-tab-target]"));
    const panels = Array.from(tabs.querySelectorAll("[data-tab-panel]"));

    const selectTab = (selected) => {
      buttons.forEach((button) => {
        const active = button === selected;
        button.setAttribute("aria-selected", String(active));
        button.tabIndex = active ? 0 : -1;
      });

      panels.forEach((panel) => {
        panel.hidden = panel.dataset.tabPanel !== selected.dataset.tabTarget;
      });
    };

    buttons.forEach((button, index) => {
      button.addEventListener("click", () => selectTab(button));
      button.addEventListener("keydown", (event) => {
        if (event.key !== "ArrowLeft" && event.key !== "ArrowRight") return;
        event.preventDefault();
        const direction = event.key === "ArrowRight" ? 1 : -1;
        const next = buttons[(index + direction + buttons.length) % buttons.length];
        selectTab(next);
        next.focus();
      });
    });

    const initial = buttons.find((button) => button.getAttribute("aria-selected") === "true") || buttons[0];
    if (initial) selectTab(initial);
  });
});
