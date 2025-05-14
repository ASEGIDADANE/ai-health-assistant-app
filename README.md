# AI-Driven Health Assistance App
## Requirements

### 1. Project Overview
The AI-driven health assistance app aims to provide users with personalized and general health support through two core features: a Personalized AI Doctor and a General AI Doctor. The Personalized AI Doctor collects detailed user information (e.g., medical history, lifestyle, symptoms) to deliver tailored health insights, recommendations, and preliminary diagnoses. The General AI Doctor addresses broader health queries with evidence-based information, suitable for users seeking general advice without personalization.

### 2. Functional Requirements

#### 2.1 User Onboarding and Profile Creation
* **Purpose:** Collect detailed user information to enable personalized health recommendations.
* **Features:**
    * Users sign up via email.
    * Initial questionnaire collects:
        * Demographic details (age, gender, height, weight).
        * Medical history (chronic conditions, allergies, medications).
        * Lifestyle factors (diet, exercise, sleep patterns, stress levels).
        * Current symptoms or health concerns (optional).
    * Option to skip personalization for General AI Doctor access.
    * Secure storage of user data with encryption.
* **Output:** A completed user health profile accessible to the Personalized AI Doctor.

#### 2.2 Personalized AI Doctor
* **Purpose:** Provide tailored health insights based on user-specific data.
* **Features:**
   ## 🤖 AI Symptom Checker

   ### How it works:
   - Users enter symptoms via text or voice (e.g., "I have a fever and headache").
   - AI asks follow-up questions to gather context (e.g., duration, severity).
   - It analyzes inputs using medical knowledge and the user’s health profile.
   
   ### Outputs:
   - Possible conditions (e.g., flu, dehydration).
   - Next steps (rest, visit doctor, urgent care warning).
   
   ---
   
   ## 💡 Personalized Health Recommendations
   
   ### Based on user profile (age, conditions, habits):
   - Diet & exercise tips  
   - Medication reminders  
   - Health check-up alerts  
   - Educational content (articles, videos)

   

#### 2.3 General AI Doctor
* **Purpose:** Address general health inquiries with evidence-based information.
* **Features:**
    * **General Health Q&A:**
        * Users ask general health questions (e.g., "What are the common symptoms of the flu?").
        * AI processes the query using NLP.
        * AI retrieves and provides an evidence-based answer.
    * **General Content Retrieval:**
        * Users search for articles, videos, and educational content on specific health topics or keywords.
        * AI retrieves relevant resources.
    * **General Triage:**
        * Users input symptom text.
        * AI assesses the urgency level (e.g., urgent, non-urgent, emergency).
      
          

#### 2.4 Multilingual Support
* **Translation pipeline:**
    * Auto-translate non-English queries via Google Translate API or multilingual NLP model (e.g., mBERT).
    * Return responses in original language.

#### 2.5 Additional Functional Notes
* **Access Control Logic:**
    * If user chooses Personalized AI Doctor, block access unless profile is complete.
    * If user chooses General AI Doctor, skip profile and allow anonymous queries.
    * On the backend: Middleware must check for profile completeness before routing to `/personalized/*`.

#### 2.6 API Endpoints
* `POST /auth/signup`: User registration.
* `POST /auth/login`: User login.
* `GET /user/profile`: Retrieve user profile.
* `POST /user/profile`: Update user profile.
* `POST /personalized/symptom_check`: Submit symptoms and receive potential conditions and recommendations.
* `POST /personalized/recommendations`: Get personalized health recommendations.
* `GET /general/qna`: Submit a general health question and receive an evidence-based answer.
* `GET /general/content`: Input: topic or keyword; Output: Articles, videos, and educational content.
* `GET /general/triage`: Input: symptom text; Output: urgency level (e.g., urgent, non-urgent, emergency).

#### 2.7 AI Workflow
* **Personalized AI Doctor:**
    1. User inputs symptoms or asks a question.
    2. Backend retrieves the user's health profile.
    3. NLP model analyzes the input in the context of the user's profile.
    4. Query a knowledge base (e.g., PubMed, WHO content, local DB).
    5. Generate a personalized response or recommendations.
* **General AI Doctor:**
    * **No Profile Required**
    1. NLP model classifies intent & extracts entities.
    2. Query a knowledge base (e.g., PubMed, WHO content, local DB).
    3. Use a Rule-Based + ML Triage System to assess urgency.

### 3. Backend Requirements
* **Data Storage:**
    * **Profiles:** SQL or NoSQL (e.g., PostgreSQL with JSONB, or MongoDB).
    * **AI Model Results:** Can be cached in Redis for faster access.
    * **Audit Logs:** Track queries, responses, and actions for debugging and safety.
* **Logs & Analytics:**
    * Log all symptom checks and queries (with anonymized identifiers).
    * Track model predictions and recommendation success for feedback loops.
* **Compliance & Security:**
    * Secure data at rest and in transit (TLS).
    * Use access scopes and roles (admin, user).
    * GDPR-compliant data deletion (for user-requested profile removal).
