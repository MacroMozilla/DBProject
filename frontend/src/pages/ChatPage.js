import { useEffect, useState } from "react";
import Inbox from "../components/Inbox";
import WorkspaceList from "../components/WorkspaceList";
import ChannelList from "../components/ChannelList";
import ChatWindow from "../components/ChatWindow";

import CreateWorkspaceModal from "../components/CreateWorkspaceModal";
import CreateChannelModal from "../components/CreateChannelModal";

import {
  fetchWorkspaces,
  fetchChannels,
  fetchMessages,
  fetchInvites,
  sendMessage,
  acceptInvite,
  rejectInvite,
  createChannel,
  logout,
} from "../services/api";

function ChatPage({ user, setUser }) {
  const [messages, setMessages] = useState([]);
  const [channels, setChannels] = useState([]);
  const [workspaces, setWorkspaces] = useState([]);
  const [invites, setInvites] = useState([]);

  const [input, setInput] = useState("");
  const [showInbox, setShowInbox] = useState(false);

  const [showCreateWorkspace, setShowCreateWorkspace] = useState(false);
  const [showCreateChannel, setShowCreateChannel] = useState(false);

  const [wsid, setWsid] = useState(null);
  const [chid, setChid] = useState(null);

  // =========================
  // INITIAL LOAD
  // =========================
  useEffect(() => {
    fetchWorkspaces().then(setWorkspaces);
    fetchInvites().then(setInvites);
  }, []);

  // =========================
  // LOAD CHANNELS when workspace changes
  // =========================
  useEffect(() => {
    if (!wsid) return;
    setChid(null); // clear selected channel when switching workspaces
    fetchChannels(wsid).then((data) => {
      setChannels(data);
    });
  }, [wsid]);

  // =========================
  // LOAD MESSAGES
  // =========================
  useEffect(() => {
    if (!chid) return;
    fetchMessages(chid).then(setMessages);
  }, [chid]);

  // =========================
  // CLOSE INBOX ON OUTSIDE CLICK
  // =========================
  useEffect(() => {
    const handleClick = () => setShowInbox(false);
    if (showInbox) window.addEventListener("click", handleClick);
    return () => window.removeEventListener("click", handleClick);
  }, [showInbox]);

  // =========================
  // ACTIONS
  // =========================
  const handleSend = async () => {
    if (!input.trim()) return;
    await sendMessage(chid, input);
    setInput("");
    fetchMessages(chid).then(setMessages);
  };

  const handleAccept = async (id, type) => {
    await acceptInvite(id, type);
    fetchInvites().then(setInvites);
    fetchWorkspaces().then(setWorkspaces);
  };

  const handleReject = async (id, type) => {
    await rejectInvite(id, type);
    fetchInvites().then(setInvites);
  };

  const handleCreateWorkspace = async () => {
    // Creation + invites are handled inside CreateWorkspaceModal.
    // This callback just refreshes the workspace list.
    setShowCreateWorkspace(false);
    const updated = await fetchWorkspaces();
    setWorkspaces(updated);
  };

  const handleCreateChannel = async (name, type) => {
    const channel = await createChannel(wsid, name, type);
    // Refetch channels and auto-select the new one
    const updated = await fetchChannels(wsid);
    setChannels(updated);
    if (channel?.chid) setChid(channel.chid);
    return channel;
  };

  const currentChannelName =
    channels.find((c) => c.chid === chid)?.chname || "";

  // =========================
  // UI
  // =========================
  return (
    <div className="h-screen flex flex-col bg-gray-100">

      {/* TOP BAR */}
      <div className="flex justify-between items-center px-6 py-3 bg-[#240057] text-white shadow">
        <h1 className="font-semibold text-lg">snickr</h1>

        <div className="flex items-center gap-4 relative">
          <span className="text-sm">{user.username}</span>

          {/* INBOX */}
          <div className="relative">
            <button
              onClick={(e) => {
                e.stopPropagation();
                setShowInbox(!showInbox);
              }}
              className="bg-white/10 px-3 py-1 rounded hover:bg-white/20"
            >
              Inbox ({invites.length})
            </button>

            {showInbox && (
              <Inbox
                invites={invites}
                onAccept={handleAccept}
                onReject={handleReject}
              />
            )}
          </div>

          {/* LOGOUT */}
          <button
            onClick={async () => {
              await logout();
              window.location.reload();
            }}
            className="bg-red-500 px-3 py-1 rounded hover:bg-red-600"
          >
            Logout
          </button>
        </div>
      </div>

      {/* MAIN LAYOUT */}
      <div className="flex flex-1 overflow-hidden">

        {/* WORKSPACES */}
        <div className="w-48 bg-[#240057] text-white p-4 overflow-y-auto">
          <WorkspaceList
            workspaces={workspaces}
            wsid={wsid}
            setWsid={setWsid}
            onCreateWorkspace={() => setShowCreateWorkspace(true)}
          />
        </div>

        {/* CHANNELS */}
        <div className="w-56 bg-gray-200 p-4 overflow-y-auto border-r">
          <ChannelList
            channels={channels}
            chid={chid}
            setChid={setChid}
            onCreateChannel={() => setShowCreateChannel(true)}
          />
        </div>

        {/* CHAT */}
        <div className="flex-1 flex flex-col bg-white">
          <ChatWindow
            messages={messages}
            input={input}
            setInput={setInput}
            sendMessage={handleSend}
            chid={chid}
            user={user}
            channelName={currentChannelName}
          />
        </div>
      </div>

      {/* MODALS */}
      {showCreateWorkspace && (
        <CreateWorkspaceModal
          onClose={() => setShowCreateWorkspace(false)}
          onCreate={handleCreateWorkspace}
        />
      )}

      {showCreateChannel && wsid && (
        <CreateChannelModal
          wsid={wsid}                              // ← was missing before
          onClose={() => setShowCreateChannel(false)}
          onCreate={handleCreateChannel}
        />
      )}
    </div>
  );
}

export default ChatPage;