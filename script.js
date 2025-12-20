document.addEventListener('DOMContentLoaded', () => {
    // --- Constants & State ---
    const TOTAL_DAYS = 365;
    const STORAGE_KEY = 'retoAhorroData_v1';

    let state = {
        pickedNumbers: [] // Array of numbers that have been picked
    };

    // --- DOM Elements ---
    const totalSavedEl = document.getElementById('total-saved');
    const daysLeftEl = document.getElementById('days-left');
    const progressFillEl = document.getElementById('progress-fill');
    const progressTextEl = document.getElementById('progress-text');
    const pickBtn = document.getElementById('pick-btn');
    const numbersGrid = document.getElementById('numbers-grid');

    // Modal Elements
    const modal = document.getElementById('modal');
    const modalTitle = document.getElementById('modal-title');
    const modalNumber = document.getElementById('modal-number');
    const modalAmount = document.getElementById('modal-amount');
    const modalConfirmBtn = document.getElementById('modal-confirm-btn');
    const closeBtn = document.querySelector('.close-btn');

    // --- Initialization ---
    function init() {
        loadData();
        renderGrid();
        updateStats();
    }

    // --- Data Management ---
    function loadData() {
        const stored = localStorage.getItem(STORAGE_KEY);
        if (stored) {
            state = JSON.parse(stored);
        }
    }

    function saveData() {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
    }

    // --- Core Logic ---
    function getAvailableNumbers() {
        const all = Array.from({ length: TOTAL_DAYS }, (_, i) => i + 1);
        return all.filter(n => !state.pickedNumbers.includes(n));
    }

    function calculateTotal() {
        return state.pickedNumbers.reduce((sum, n) => sum + (n * 100), 0);
    }

    function formatMoney(amount) {
        return '$' + amount.toLocaleString('es-CO');
    }

    // --- UI/UX Functions ---
    function updateStats() {
        const total = calculateTotal();
        const count = state.pickedNumbers.length;
        const remaining = TOTAL_DAYS - count;
        const percent = (count / TOTAL_DAYS) * 100;

        totalSavedEl.textContent = formatMoney(total);
        daysLeftEl.textContent = remaining;

        progressFillEl.style.width = `${percent}%`;
        progressTextEl.textContent = `${percent.toFixed(1)}%`;

        if (remaining === 0) {
            pickBtn.textContent = "¡RETO COMPLETADO!";
            pickBtn.disabled = true;
            celebrate();
        }
    }

    function renderGrid() {
        numbersGrid.innerHTML = '';
        for (let i = 1; i <= TOTAL_DAYS; i++) {
            const div = document.createElement('div');
            div.classList.add('grid-item');

            if (state.pickedNumbers.includes(i)) {
                div.classList.add('picked');
                div.innerHTML = ''; // Helper CSS handles icon
            } else {
                const span = document.createElement('span');
                span.textContent = i;
                div.appendChild(span);
            }

            numbersGrid.appendChild(div);
        }
    }

    function pickNumber() {
        const available = getAvailableNumbers();

        if (available.length === 0) {
            showModal(null, true);
            return;
        }

        const randomIndex = Math.floor(Math.random() * available.length);
        const number = available[randomIndex];

        // Update State
        state.pickedNumbers.push(number);
        saveData();

        // Visual Feedback
        showModal(number);
        updateStats();

        // Update specific grid item without full re-render for performance/animation
        // But full re-render is cheap enough here. Let's do partial for style points.
        const gridItems = numbersGrid.children;
        const itemToUpdate = gridItems[number - 1];
        itemToUpdate.classList.add('picked');
        itemToUpdate.innerHTML = '';

        if (state.pickedNumbers.length === TOTAL_DAYS) {
            celebrate();
        } else {
            // Small confetti pop (Safe check)
            if (typeof confetti === 'function') {
                confetti({
                    particleCount: 100,
                    spread: 70,
                    origin: { y: 0.6 }
                });
            }
        }
    }

    // --- Modal Functions ---
    function showModal(number, completed = false) {
        if (completed) {
            modalTitle.textContent = "¡FELICIDADES!";
            modalNumber.style.display = 'none';
            document.querySelector('.modal-subtitle').textContent = "Has completado el reto y ahorrado:";
            modalAmount.textContent = formatMoney(calculateTotal()); // Final total
        } else {
            modalTitle.textContent = "¡Número del Día!";
            modalNumber.style.display = 'block';
            modalNumber.textContent = number;
            document.querySelector('.modal-subtitle').textContent = "Debes ahorrar:";
            modalAmount.textContent = formatMoney(number * 100);
        }

        modal.classList.remove('hidden');
        modal.style.display = 'flex'; // Force display just in case
    }

    function closeModal() {
        modal.classList.add('hidden');
        // Wait for animation to finish before hiding display? 
        // For simplicity, just timeout or let css handle opacity
        setTimeout(() => {
            if (modal.classList.contains('hidden')) modal.style.display = 'none';
        }, 300);
    }

    // --- Confetti ---
    function celebrate() {
        if (typeof confetti !== 'function') return;

        var duration = 5 * 1000;
        var animationEnd = Date.now() + duration;
        var defaults = { startVelocity: 30, spread: 360, ticks: 60, zIndex: 0 };

        var interval = setInterval(function () {
            var timeLeft = animationEnd - Date.now();

            if (timeLeft <= 0) {
                return clearInterval(interval);
            }

            var particleCount = 50 * (timeLeft / duration);
            // since particles fall down, start a bit higher than random
            confetti(Object.assign({}, defaults, { particleCount, origin: { x: randomInRange(0.1, 0.3), y: Math.random() - 0.2 } }));
            confetti(Object.assign({}, defaults, { particleCount, origin: { x: randomInRange(0.7, 0.9), y: Math.random() - 0.2 } }));
        }, 250);
    }

    function randomInRange(min, max) {
        return Math.random() * (max - min) + min;
    }

    // --- Event Listeners ---
    pickBtn.addEventListener('click', pickNumber);
    closeBtn.addEventListener('click', closeModal);
    modalConfirmBtn.addEventListener('click', closeModal);

    // Toggle Grid
    const toggleGridBtn = document.getElementById('toggle-grid-btn');
    const gridWrapper = document.getElementById('grid-wrapper');

    toggleGridBtn.addEventListener('click', () => {
        const isCollapsed = gridWrapper.classList.contains('collapsed');
        if (isCollapsed) {
            gridWrapper.classList.remove('collapsed');
            toggleGridBtn.textContent = 'Ocultar';
        } else {
            gridWrapper.classList.add('collapsed');
            toggleGridBtn.textContent = 'Ver Todos';
        }
    });

    // Close modal on outside click
    window.addEventListener('click', (e) => {
        if (e.target === modal) {
            closeModal();
        }
    });

    // Start
    init();
});
