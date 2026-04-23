const BASE_URL = "http://localhost:8000/api/core";

export const apiCall = async (func, args = [], kwargs = {}) => {
  const res = await fetch(BASE_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    credentials: "include",
    body: JSON.stringify({
      function: func,
      args,
      kwargs,
    }),
  });

  const data = await res.json();
  console.log("API RAW RESPONSE:", data);

  if (!data.ok) {
    throw new Error(data.error || "API error");
  }

  if (data.data?.error) {
    throw new Error(data.data.error);
  }

  return data.data;
};

// AUTH
export const login = (username, password) =>
  apiCall("login", [], { username, password });

export const register = (email, username, nickname, password) =>
  apiCall("register", [], { email, username, nickname, password });

export const logout = () =>
  apiCall("logout");

// WORKSPACES
export const fetchWorkspaces = () =>
  apiCall("get_workspaces");

export const createWorkspace = (name, description, usernames) =>
  apiCall("create_workspace", [], { name, description, usernames });

// CHANNELS
export const fetchChannels = (wsid) =>
  apiCall("get_channels", [wsid]);

export const createChannel = (wsid, name, type, usernames) =>
  apiCall("create_channel", [], { wsid, name, type, usernames });

// MESSAGES
export const fetchMessages = (chid) =>
  apiCall("get_messages", [chid]);

export const sendMessage = (chid, content) =>
  apiCall("send_message", [chid, content]);

// INVITES
export const fetchInvites = () =>
  apiCall("get_invitations");

export const acceptInvite = (id, type) =>
  type === "workspace"
    ? apiCall("respond_workspace_invite", [id, true])
    : apiCall("respond_channel_invite", [id, true]);

export const rejectInvite = (id, type) =>
  type === "workspace"
    ? apiCall("respond_workspace_invite", [id, false])
    : apiCall("respond_channel_invite", [id, false]);