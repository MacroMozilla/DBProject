import { useEffect, useState } from "react";
import { apiCall } from "./services/api";
import LoginPage from "./pages/LoginPage";
import ChatPage from "./pages/ChatPage";

function App() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const checkSession = async () => {
      try {
        const me = await apiCall("me");
        setUser(me);
      } catch {
        setUser(null);
      } finally {
        setLoading(false);
      }
    };

    checkSession();
  }, []);

  if (loading) return <div>Loading...</div>;

  if (!user) {
    return <LoginPage setUser={setUser} />;
  }

  return <ChatPage user={user} setUser={setUser} />;
}

export default App;