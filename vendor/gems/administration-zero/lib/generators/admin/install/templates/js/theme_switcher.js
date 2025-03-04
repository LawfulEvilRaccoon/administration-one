import { Controller } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"

Stimulus.register("theme-switcher", class extends Controller {
  connect() { 
    // Auto-switcher part

    const getStoredTheme = () => localStorage.getItem('theme');

    function getPreferredTheme() {
      const storedTheme = getStoredTheme();

      if (storedTheme === 'light') {
        return 'light';
      } else if (storedTheme === 'dark') {
        return 'dark';
      } else if (storedTheme === 'auto') { 
        return 'auto';
      } else {
        return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
      };
    };

    function setTheme(theme) {
      if (theme !== 'light' && theme !== 'dark') {
        const theme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
        document.documentElement.setAttribute('data-bs-theme', theme);
      } else {
        document.documentElement.setAttribute('data-bs-theme', theme);
      };
    };

    // Switch by hand

    const themeSwitcher = document.getElementsByClassName('theme-switcher')[0];
    const switcherIcon = themeSwitcher.getElementsByClassName('switcher')[0];

    const lightThemeIcon = '<svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="1"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-sun"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 12m-4 0a4 4 0 1 0 8 0a4 4 0 1 0 -8 0" /><path d="M3 12h1m8 -9v1m8 8h1m-9 8v1m-6.4 -15.4l.7 .7m12.1 -.7l-.7 .7m0 11.4l.7 .7m-12.1 -.7l-.7 .7" /></svg>';
    const darkThemeIcon = '<svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="1"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-moon"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 3c.132 0 .263 0 .393 0a7.5 7.5 0 0 0 7.92 12.446a9 9 0 1 1 -8.313 -12.454z" /></svg>';
    const autoThemeIcon = '<svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="1"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-percentage-50"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 21a9 9 0 0 0 0 -18m0 0v18" fill="currentColor" stroke="none" /><path d="M3 12a9 9 0 1 0 18 0a9 9 0 0 0 -18 0" /></svg>';

    function setSwitcherIconAndTooltip(theme) {
      if (theme == 'light') {
        themeSwitcher.innerHTML = lightThemeIcon;
        themeSwitcher.setAttribute('data-bs-original-title', 'Switch theme to dark');
      } else if (theme == 'dark') {
        themeSwitcher.innerHTML = darkThemeIcon;
        themeSwitcher.setAttribute('data-bs-original-title', 'Switch theme to system');
      } else {
        themeSwitcher.innerHTML = autoThemeIcon;
        themeSwitcher.setAttribute('data-bs-original-title', 'Switch theme to light');
      };
    };

    function switchTheme() {
      let theme = getPreferredTheme()
      if (theme === 'light') {
        localStorage.setItem('theme', 'dark');
        setTheme('dark');
        setSwitcherIconAndTooltip('dark');
      } else if (theme === 'dark') {
        localStorage.setItem('theme', 'auto');
        setTheme(getPreferredTheme());
        setSwitcherIconAndTooltip('auto');
      } else {
        localStorage.setItem('theme', 'light');
        setTheme('light');
        setSwitcherIconAndTooltip('light');
      };
    };

    // Triggers

    setTheme(getPreferredTheme());
    setSwitcherIconAndTooltip(getPreferredTheme());

    window.addEventListener('turbo:load', () => {
      setTheme(getPreferredTheme());
      setSwitcherIconAndTooltip(getPreferredTheme());
    });

    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
      const storedTheme = getStoredTheme();
      if (storedTheme !== 'light' && storedTheme !== 'dark') {
        setTheme(getPreferredTheme());
        setSwitcherIconAndTooltip(getPreferredTheme());
      };
    });

    themeSwitcher.onclick = () => {
      switchTheme();
    };
  };
});