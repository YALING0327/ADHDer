import adhderMarkdown from 'adhder-markdown';

export default function markdown (el, { value, oldValue }) {
  if (value === oldValue) return;

  if (value) {
    el.innerHTML = adhderMarkdown.render(String(value));
  } else {
    el.innerHTML = '';
  }

  el.classList.add('markdown');
}
