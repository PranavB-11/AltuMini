# Altu Mini

---

## Instructions

To run Altu Mini locally, you only need to take three steps:

1.  **Clone:** `git clone https://github.com/PranavB-11/AltuMini`
2.  **API Key Setup:** Enter your Gemini API Key in `Services/GeminiService.swift`. The free tier is sufficient for testing this application.
3.  **Build:** Build and run the project using **iOS 18.6** or newer.

---

## Architecture Overview

The project is structured following the MVVM (Model-View-ViewModel) pattern, with specialized folders for each component.

| Folder | Contents & Role |
| :--- | :--- |
| **Model** | Defines crucial data structures (`struct`s) used across the application logic, including the necessary request and response outlines for the **LLM** communication. |
| **Resources** | Contains the raw **JSON files** (`health_daily.json` and `screentime.json`) that provide the application's mock health data. |
| **Services** | Houses helper classes responsible for data loading (from JSON files) and initializing the **Gemini API** interface. |
| **ViewModel** | Defines the logic for the two main pages: **`DashboardViewModel`** (handles data processing and metric display) and **`AskAltuViewModel`** (manages the conversation infrastructure and the LLM's **system prompt**). |
| **Views** | Contains all the SwiftUI files responsible for the visual aspect (frontend/UI). This acts as the Swift equivalent of HTML/CSS. |
| **AltuMiniApp** | The main application entry point, where **`ContentView`** organizes the two primary pages (Dashboard and AskAltu). |

---

## Development Process

### The Dashboard: Data Visualization

The initial focus was on delivering a high-level, interactive data experience within a 5-hour time constraint.

1.  **Baseline Data:** The application first loads and visualizes daily health metrics.
2.  **Relationship Exploration:** Using intuition that **sleep, steps, and exercise minutes** affect each other, a **scatter plot** was created to visually explore the correlation between these three variables.
3.  **Screen Time Breakdown:** Given the hierarchical nature of screen time logs, a modular **breakdown of apps and their respective usage times** was chosen over a complex visual graph.
4.  **Interactivity:** Graphs were designed to support basic user interaction via press-and-hold/drag gestures to inspect specific data points.

### Ask Altu: Conversational AI

The conversational feature utilizes the **Gemini model** by passing the full content of the two health JSONs as context.

* **Contextual Feedback:** The model operates under a strict **system prompt** (defined in `AskAltuViewModel`) that instructs it to base all feedback *only* on the user's provided data.
* **Conversation Flow:** The chat is designed to stack messages, allowing the model to build upon previous turns within a single conversation session. (Note: These chats are ephemeral and are not stored across app sessions).

### How I used AI to Write Code

Nearly all the design and logical elements were either written or pseudocoded by me. An AI assistant has refined my code, wrote all of the error handling logic, and quite a lot of the frontend since I'm not super comfortable with Swift UI yet (used it like a CSS -> SwiftUI translator). Of course, the assistant was super helpful with debugging as well.

---

## Tradeoffs

| Area | Tradeoff |
| :--- | :--- |
| **Latency/Payload** | **Full JSONs vs. Aggregate Data.** Passing the **full 90-day data stack** to Gemini provides highly accurate feedback but creates a massive latency bottleneck (even simple greetings took several seconds). The benefit of full data knowledge currently outweighs the performance cost. |
| **System Prompting** | **Exploration vs. Discipline.** Balancing the model's freedom to use its general knowledge against strict discipline to use only the user's data was tricky. The **"safest" option**—to only use user data—was chosen for reliable, data-grounded responses. |

---

## Future Development (With More Time)

If given more time, the next priorities would be to focus on performance and robustness:

* **Performance:**
    * **Fix Latency:** Implement streaming output (as attempted) to improve the conversational flow.
    * **Context Optimization:** Utilize vectorization and indexing libraries to tokenize and retrieve only relevant data chunks, minimizing the context payload and improving runtime.
* **Model/Prompting:**
    * **Refine System Prompt:** Address the balance between model exploration and discipline.
    * **Conversation Bugs:** Fix annoying conversational errors (e.g., the model repeatedly saying "Hello, I'm Altu").
* **UI/Output Formatting:**
    * **Structured Output:** Fix issues where the model attempts to output complex structures (like tables), which often format horrifically on SwiftUI.
    * **Enhanced Graphs:** Make the existing graphs more interactive, and perhaps introduce a **3D graph** for a fascinating new way to explore multi-dimensional data relationships and patterns.
