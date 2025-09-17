const state = {
    hints: [],
    tasks: [],
};

const suggestions = {
    themes: ["Abenteuer", "Natur", "Weltraum", "Magie", "Detektiv", "Zeitreise", "Unterwasser", "Safari"],
    stories: {
        Abenteuer: [
            "In einer geheimen Höhle liegt eine alte Schatztruhe versteckt. Nur wer die Zeichen an der Wand richtig liest, findet den Schlüssel.",
            "Ein mutiger Pirat hat den nächsten Hinweis hinter einer kniffligen Botschaft versteckt. Wer kann den Reim lösen?",
        ],
        Natur: [
            "Im Wald haben die Tiere eine Nachricht hinterlassen. Folge den Geräuschen und finde heraus, wer den Schatz bewacht.",
            "Zwischen Moos und Blättern wartet eine Rätselgeschichte. Welche Pflanze zeigt dir den richtigen Weg?",
        ],
        Weltraum: [
            "Auf dem Mond ist eine Sternenkarte verloren gegangen. Finde heraus, welches Sternbild euch zum Ziel führt.",
            "Ein kleiner Roboter hat eine geheime Nachricht gesendet. Entschlüssele sie, um die Galaxy-Medaille zu erhalten.",
        ],
        Magie: [
            "Ein vergessener Zauber steckt im Rätselbuch der Hexe. Nur wer die richtigen Zutaten nennt, kann den Funken finden.",
            "Im Schloss des Zauberers sind die Bilder durcheinander geraten. Ordne sie und finde das goldene Amulett.",
        ],
        Detektiv: [
            "Im Detektivbüro liegt ein verschlüsselter Brief. Wer die Spuren richtig kombiniert, entdeckt die Lösung.",
            "Ein Dieb hat Hinweise hinterlassen: Welche drei Gegenstände erzählen die Wahrheit?",
        ],
    },
    hints: {
        Abenteuer: ["Folge dem Pfad aus Seilen", "Zähle die Schritte bis zur Palme", "Höre auf das Rascheln"],
        Natur: ["Schau unter die Blätter", "Wie viele Vogelhäuschen siehst du?", "Der Wind verrät dir etwas"],
        Weltraum: ["Markiere die hellsten Sterne", "Nur ein Planet hat Ringe", "Der Meteor zeigt nach Osten"],
        Magie: ["Suche nach glitzerndem Staub", "Sprich den Zauberspruch laut", "Eine Feder führt dich weiter"],
        Detektiv: ["Vergleiche die Fußspuren", "Ein verrücktes Bild verrät etwas", "Die Lupe hilft dir weiter"],
        default: ["Notiere alles, was du siehst", "Achte auf Farben", "Höre genau zu", "Zähle besondere Gegenstände"],
    },
};

const form = document.querySelector("#riddle-form");
const hintList = document.querySelector("#hint-list");
const hintInput = document.querySelector("#hint-input");
const taskList = document.querySelector("#task-list");
const taskTemplate = document.querySelector("#task-template");
const previewElements = {
    title: document.querySelector("#preview-title"),
    meta: document.querySelector("#preview-meta"),
    story: document.querySelector("#preview-story"),
    hints: document.querySelector("#preview-hints"),
    tasks: document.querySelector("#preview-tasks"),
    answer: document.querySelector("#preview-answer"),
    reward: document.querySelector("#preview-reward"),
};

const buttons = document.querySelectorAll("[data-action]");

function getSelectedTheme() {
    const themeField = form.elements["theme"];
    return themeField?.value || "Abenteuer";
}

function randomItem(list) {
    return list[Math.floor(Math.random() * list.length)];
}

function addHint(text) {
    if (!text) return;
    state.hints.push(text);
    renderHintList();
    hintInput.value = "";
    hintInput.focus();
}

function removeHint(index) {
    state.hints.splice(index, 1);
    renderHintList();
}

function renderHintList() {
    hintList.innerHTML = "";
    state.hints.forEach((hint, index) => {
        const item = document.createElement("li");
        const span = document.createElement("span");
        span.textContent = hint;
        const button = document.createElement("button");
        button.type = "button";
        button.textContent = "×";
        button.setAttribute("aria-label", "Hinweis entfernen");
        button.addEventListener("click", () => removeHint(index));
        item.append(span, button);
        hintList.append(item);
    });
}

function addTask(initialValue = "") {
    const clone = taskTemplate.content.firstElementChild.cloneNode(true);
    const input = clone.querySelector("input");
    const removeBtn = clone.querySelector("button");
    input.value = initialValue;
    removeBtn.addEventListener("click", () => {
        clone.remove();
        collectTasks();
        updatePreview();
    });
    input.addEventListener("input", () => {
        collectTasks();
        updatePreview();
    });
    taskList.append(clone);
    input.focus();
    collectTasks();
}

function collectTasks() {
    const values = Array.from(taskList.querySelectorAll("input"))
        .map((input) => input.value.trim())
        .filter(Boolean);
    state.tasks = values;
}

function suggestStory() {
    const theme = getSelectedTheme();
    const themeStories = suggestions.stories[theme] || suggestions.stories.Abenteuer;
    const suggestion = randomItem(themeStories);
    form.elements["story"].value = suggestion;
}

function suggestHint() {
    const theme = getSelectedTheme();
    const pool = [...(suggestions.hints[theme] || []), ...suggestions.hints.default];
    const hint = randomItem(pool);
    hintInput.value = hint;
    hintInput.focus();
}

function suggestTheme() {
    const themeField = form.elements["theme"];
    const suggestion = randomItem(suggestions.themes);
    themeField.value = suggestion;
}

function generatePreview() {
    const formData = new FormData(form);
    const title = formData.get("title")?.toString().trim();
    const story = formData.get("story")?.toString().trim();
    const answer = formData.get("answer")?.toString().trim();
    const reward = formData.get("reward")?.toString().trim();
    const theme = formData.get("theme");
    const difficulty = formData.get("difficulty");
    const format = formData.get("format");

    if (title) {
        previewElements.title.textContent = title;
    } else {
        previewElements.title.textContent = "Dein Rätsel wartet auf einen Titel";
    }

    previewElements.meta.textContent = `Thema: ${theme} · Schwierigkeit: ${difficulty} · Typ: ${format}`;
    previewElements.story.textContent = story || "Nutze den Textbereich, um die Geschichte oder Frage aufzuschreiben.";

    renderPreviewList(previewElements.hints, "Hinweise", state.hints);
    renderPreviewList(previewElements.tasks, "Mini-Aufgaben", state.tasks);

    previewElements.answer.textContent = answer ? `Lösung: ${answer}` : "Lösung noch offen – lass die Kinder weiter knobeln!";
    previewElements.reward.textContent = reward ? `Belohnung/Station: ${reward}` : "";
}

function renderPreviewList(container, heading, items) {
    container.innerHTML = "";
    if (!items.length) return;
    const title = document.createElement("h4");
    title.textContent = heading;
    const list = document.createElement("ul");
    items.forEach((entry) => {
        const li = document.createElement("li");
        li.textContent = entry;
        list.append(li);
    });
    container.append(title, list);
}

function copyText() {
    const text = buildExportText();
    if (navigator.clipboard?.writeText) {
        navigator.clipboard.writeText(text).then(() => showFeedback("copy", "Kopiert!"));
    } else {
        const textarea = document.createElement("textarea");
        textarea.value = text;
        document.body.append(textarea);
        textarea.select();
        document.execCommand("copy");
        textarea.remove();
        showFeedback("copy", "Kopiert!");
    }
}

function buildExportText() {
    const pieces = [
        previewElements.title.textContent,
        previewElements.meta.textContent,
        "",
        previewElements.story.textContent,
    ];

    if (state.hints.length) {
        pieces.push("Hinweise:");
        state.hints.forEach((hint, index) => pieces.push(`${index + 1}. ${hint}`));
        pieces.push("");
    }

    if (state.tasks.length) {
        pieces.push("Mini-Aufgaben:");
        state.tasks.forEach((task, index) => pieces.push(`${index + 1}. ${task}`));
        pieces.push("");
    }

    if (previewElements.answer.textContent) pieces.push(previewElements.answer.textContent);
    if (previewElements.reward.textContent) pieces.push(previewElements.reward.textContent);

    return pieces.join("\n");
}

function updatePreview() {
    generatePreview();
}

function showFeedback(action, label) {
    const button = document.querySelector(`[data-action="${action}"]`);
    if (!button) return;
    const original = button.textContent;
    button.textContent = label;
    button.disabled = true;
    setTimeout(() => {
        button.textContent = original;
        button.disabled = false;
    }, 1800);
}

function downloadAsPdf() {
    window.print();
}

function handleButtonClick(event) {
    const action = event.target.dataset.action;
    switch (action) {
        case "add-hint": {
            const value = hintInput.value.trim();
            if (value) {
                addHint(value);
            } else {
                suggestHint();
            }
            break;
        }
        case "suggest-hint": {
            suggestHint();
            break;
        }
        case "add-task": {
            addTask();
            break;
        }
        case "generate": {
            collectTasks();
            generatePreview();
            showFeedback("generate", "Aktualisiert!");
            break;
        }
        case "copy": {
            collectTasks();
            generatePreview();
            copyText();
            break;
        }
        case "download": {
            collectTasks();
            generatePreview();
            downloadAsPdf();
            break;
        }
        case "suggest-theme": {
            suggestTheme();
            break;
        }
        case "suggest-story": {
            suggestStory();
            break;
        }
        default:
            break;
    }
}

buttons.forEach((button) => button.addEventListener("click", handleButtonClick));

form.addEventListener("submit", (event) => {
    event.preventDefault();
});

form.addEventListener("reset", () => {
    state.hints = [];
    state.tasks = [];
    renderHintList();
    taskList.innerHTML = "";
    setTimeout(() => {
        form.querySelector("#title").focus();
    }, 0);
    setTimeout(() => {
        previewElements.title.textContent = "Wähle links deine Ideen…";
        previewElements.meta.textContent = "";
        previewElements.story.textContent = "";
        previewElements.hints.innerHTML = "";
        previewElements.tasks.innerHTML = "";
        previewElements.answer.textContent = "";
        previewElements.reward.textContent = "";
    }, 0);
});

// Start mit einer Mini-Aufgabe und Beispielhinweis
addTask("Finde drei Dinge, die glänzen");
addHint("Schau nach, wo es am hellsten ist");
generatePreview();
