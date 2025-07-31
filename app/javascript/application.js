// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


const toggle = document.getElementById("menuToggle");
const navbar = document.getElementById("navbar");

toggle.addEventListener("click", () => {
    navbar.classList.toggle("active");
});