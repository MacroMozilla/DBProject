import { useState } from "react";
import { register, apiCall } from "../services/api";

function RegisterPage({ setUser, goToLogin }) {
  const [email, setEmail] = useState("");
  const [username, setUsername] = useState("");
  const [nickname, setNickname] = useState("");
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");

  const handleRegister = async () => {
    if (!email || !username || !password) {
      alert("Please fill all required fields");
      return;
    }

    if (password !== confirm) {
      alert("Passwords do not match");
      return;
    }

    try {
      await register(email, username, nickname, password);

      const me = await apiCall("me");
      setUser(me);
    } catch (err) {
      alert("Registration failed");
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-[#240057]">
      <div className="bg-white rounded-2xl shadow-lg p-8 w-full max-w-md">

        <h2 className="text-2xl font-bold text-center text-[#240057] mb-6">
          Create Account
        </h2>

        <div className="space-y-4">
          <input
            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#240057]"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />

          <input
            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#240057]"
            placeholder="Username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />

          <input
            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#240057]"
            placeholder="Nickname"
            value={nickname}
            onChange={(e) => setNickname(e.target.value)}
          />

          <input
            type="password"
            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#240057]"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />

          <input
            type="password"
            className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#240057]"
            placeholder="Confirm Password"
            value={confirm}
            onChange={(e) => setConfirm(e.target.value)}
          />
        </div>

        <button
          onClick={handleRegister}
          className="w-full mt-6 bg-[#240057] text-white py-2 rounded-lg hover:bg-purple-900 transition"
        >
          Register
        </button>

        <p className="text-center text-sm mt-4">
          Already have an account?{" "}
          <span
            onClick={goToLogin}
            className="text-[#240057] font-semibold cursor-pointer hover:underline"
          >
            Login
          </span>
        </p>
      </div>
    </div>
  );
}

export default RegisterPage;