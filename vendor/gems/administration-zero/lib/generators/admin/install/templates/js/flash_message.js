import { Controller } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"

Stimulus.register("flash-message", class extends Controller {
  connect() { new bootstrap.Toast(this.element).show() }
});