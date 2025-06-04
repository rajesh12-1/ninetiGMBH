# Flutter User Management App

A Flutter application built as part of an assessment for the **Flutter Intern** position. The app demonstrates user listing, search, infinite scrolling, detail view, and post creation using **BLoC** pattern and **DummyJSON API**.

---

## 📦 Features

### ✅ API Integration
- Integrated with [DummyJSON Users API](https://dummyjson.com/users)
- Pagination via `limit` and `skip`
- Real-time search by user name
- Infinite scroll support for user list
- Fetch user-specific:
  - 📄 Posts → `https://dummyjson.com/posts/user/{userId}`
  - ✅ Todos → `https://dummyjson.com/todos/user/{userId}`

### ✅ BLoC State Management
- `flutter_bloc` for clean separation of logic and UI
- Events and states for:
  - Fetching users
  - Searching users
  - Paginating users
  - Loading posts and todos
- Error and loading state management

### ✅ UI Screens
- **User List Screen**:
  - Displays avatar, name, and email
  - Includes a real-time search bar
- **User Detail Screen**:
  - Shows profile, posts (ListView), and todos (CheckboxList)
- **Create Post Screen**:
  - Locally adds new post (title + body)
- **LoadingIndicator Widget** for progress
- Proper **error messages** for failed states

---

## 🧱 Project Structure
lib/
├── blocs/ # BLoC files for user logic
├── models/ # Data models: user, post, todo
├── repositories/ # Abstraction over API calls
├── screens/ # UI screens: UserList, UserDetail, CreatePost
├── services/ # API service integration
├── widgets/ # Shared widgets like loading indicators
