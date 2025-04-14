import { Controller } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"

Stimulus.register("flash-message", class extends Controller {
  remove() { this.element.remove() }
});