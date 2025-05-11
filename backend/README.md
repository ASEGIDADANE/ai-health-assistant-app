# AI Health Assistant Backend

A TypeScript-based backend service for the AI Health Assistant application, providing AI-powered health consultations, symptom checking, and first aid guidance.

## Features

- 🤖 AI-powered health consultations using Google's Gemini AI
- 💬 Personalized chat with medical history context
- 🔍 Symptom checking and possible condition analysis
- 🏥 First aid guidance and instructions
- 🔐 User authentication and profile management
- 💾 MongoDB database integration
- 🔒 Secure API endpoints with rate limiting

## Prerequisites

- Node.js (v18 or higher)
- MongoDB
- Google AI API Key

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd ai-health-assistant-app/backend
```

2. Install dependencies:
```bash
npm install
```


## Project Structure 

## Available Scripts

- `npm run dev`: Start development server with hot reload
- `npm run build`: Build TypeScript files
- `npm start`: Start production server
- `npm run lint`: Run ESLint
- `npm test`: Run tests

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - User login

### AI Health Assistant
- `POST /api/ai/generate` - Generate AI response
  ```json
  {
    "prompt": "What should I do about my headache?",
    "userId": "user_id"
  }
  ```

- `GET /api/ai/history/:userId` - Get chat history

### Symptom Checker
- `POST /api/ai/symptoms` - Check symptoms
  ```json
  {
    "symptoms": "fever, headache, sore throat"
  }
  ```

### First Aid
- `POST /api/ai/first-aid` - Get first aid instructions
  ```json
  {
    "caseType": "burn"
  }
  ```

## Development

1. Start the development server:
```bash
npm run dev
```

2. The server will start at `http://localhost:5000`

## Testing

Run the test suite:
```bash
npm test
```

## Security Features

- Helmet.js for security headers
- Rate limiting to prevent abuse
- JWT authentication
- Input validation using Zod
- CORS protection

## Error Handling

The API uses a centralized error handling system with appropriate HTTP status codes and error messages.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the ISC License.

<<<<<<< HEAD
## Support

For support, email [your-email] or open an issue in the repository. 
=======
>>>>>>> 01fe6f9244707e9c4fd0dc8ebbbc74e46df05cd3
