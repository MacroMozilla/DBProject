import { useEffect, useState } from "react";
import { apiCall } from "./services/api";

import LoginPage from "./pages/LoginPage";
import RegisterPage from "./pages/RegisterPage"; // ✅ ADD THIS
import ChatPage from "./pages/ChatPage";

function App() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [showRegister, setShowRegister] = useState(false);

  useEffect(() => {
    const checkSession = async () => {
      try {
        const me = await apiCall("me");

        // 🔥 IMPORTANT: make sure it's actually a valid user
        if (me && !me.error) {
          setUser(me);
        } else {
          setUser(null);
        }

      } catch {
        setUser(null);
      } finally {
        setLoading(false);
      }
    };

    checkSession();
  }, []);

  if (loading) return <div>Loading...</div>;

  // 🔐 NOT LOGGED IN
  if (!user) {
    return showRegister ? (
      <RegisterPage
        setUser={setUser}
        goToLogin={() => setShowRegister(false)}
      />
    ) : (
      <LoginPage
        setUser={setUser}
        goToRegister={() => setShowRegister(true)}
      />
    );
  }
  
  return <ChatPage user={user} setUser={setUser} />;
}

export default App;