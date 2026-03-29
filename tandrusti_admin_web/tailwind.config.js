/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        background: '#f8fafc',
        surface: '#ffffff',
        primary: '#22c55e',          // Tandrusti accent green
        primaryDark: '#16a34a',
        textMain: '#0f172a',
        textMuted: '#64748b',
        borderLight: '#e2e8f0',
      }
    },
  },
  plugins: [],
}
