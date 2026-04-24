import { useEffect, useState } from "react";
import Inbox from "../components/Inbox";
import WorkspaceList from "../components/WorkspaceList";
import ChannelList from "../components/ChannelList";
import ChatWindow from "../components/ChatWindow";

import CreateWorkspaceModal from "../components/CreateWorkspaceModal";
import CreateChannelModal from "../components/CreateChannelModal";
import WorkspaceMembersModal from "../components/WorkspaceMembersModal";
import ChannelSettingsModal from "../components/ChannelSettingsModal";
import DiscoverChannelsModal from "../components/DiscoverChannelsModal";
import SearchModal from "../components/SearchModal";

import {
  fetchWorkspaces,
  fetchChannels,
  fetchMessages,
  fetchChannelMembers,
  fetchInvites,
  sendMessage,
  acceptInvite,
  rejectInvite,
  createChannel,
  markChannelRead,
  logout,
} from "../services/api";

function ChatPage({ user, setUser }) {
  const [messages, setMessages] = useState([]);
  const [channels, setChannels] = useState([]);
  const [workspaces, setWorkspaces] = useState([]);
  const [invites, setInvites] = useState([]);
  const [channelMembers, setChannelMembers] = useState([]);

  const [input, setInput] = useState("");
  const [showInbox, setShowInbox] = useState(false);

  const [showCreateWorkspace, setShowCreateWorkspace] = useState(false);
  const [showCreateChannel, setShowCreateChannel] = useState(false);
  const [showWsMembers, setShowWsMembers] = useState(false);
  const [showChannelSettings, setShowChannelSettings] = useState(false);
  const [showDiscover, setShowDiscover] = useState(false);
  const [showSearch, setShowSearch] = useState(false);

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
    setChid(null);
    fetchChannels(wsid).then(setChannels);
  }, [wsid]);

  // =========================
  // LOAD MESSAGES + MARK READ
  // =========================
  useEffect(() => {
    if (!chid) return;
    fetchMessages(chid).then(setMessages);
    fetchChannelMembers(chid).then((data) => setChannelMembers(data || []));
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
    if (!input.trim() || !chid) return;
    await sendMessage(chid, input);
    setInput("");
    fetchMessages(chid).then(setMessages);
    markChannelRead(chid);
  };

  const handleAccept = async (id, type) => {
    await acceptInvite(id, type);
    fetchInvites().then(setInvites);
    fetchWorkspaces().then(setWorkspaces);
    // If a channel invite was accepted, refresh the channel list immediately
    if (type === "channel" && wsid) fetchChannels(wsid).then(setChannels);
  };

  const handleReject = async (id, type) => {
    await rejectInvite(id, type);
    fetchInvites().then(setInvites);
  };

  const handleWorkspaceCreated = async () => {
    setShowCreateWorkspace(false);
    fetchWorkspaces().then(setWorkspaces);
  };

  const handleCreateChannel = async (name, type) => {
    const channel = await createChannel(wsid, name, type);
    const updated = await fetchChannels(wsid);
    setChannels(updated);
    if (channel?.chid) setChid(channel.chid);
    return channel;
  };

  const handleLeftWorkspace = async () => {
    setWsid(null);
    setChid(null);
    setChannels([]);
    fetchWorkspaces().then(setWorkspaces);
  };

  const handleJumpTo = (wsid, chid) => {
    setWsid(wsid);
    // channels will load via useEffect, then we set chid after a tick
    setTimeout(() => setChid(chid), 100);
  };

  const handleChannelGone = async () => {
    setChid(null);
    setMessages([]);
    fetchChannels(wsid).then(setChannels);
  };

  const currentChannelName = channels.find((c) => c.chid === chid)?.chname || "";

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

          {/* SEARCH */}
          <button
            onClick={() => setShowSearch(true)}
            className="bg-white/10 px-3 py-1 rounded hover:bg-white/20 text-sm"
          >
            🔍 Search
          </button>

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
              <Inbox invites={invites} onAccept={handleAccept} onReject={handleReject} />
            )}
          </div>

          <button
            onClick={async () => { await logout(); window.location.reload(); }}
            className="bg-red-500 px-3 py-1 rounded hover:bg-red-600"
          >
            Logout
          </button>
        </div>
      </div>

      {/* MAIN LAYOUT */}
      <div className="flex flex-1 overflow-hidden">

        {/* WORKSPACES SIDEBAR */}
        <div className="w-48 bg-[#240057] text-white flex flex-col overflow-hidden">
          {/* WorkspaceList renders its own header + list */}
          <div className="flex-1 overflow-y-auto px-4 pt-4 pb-2">
            <WorkspaceList
              workspaces={workspaces}
              wsid={wsid}
              setWsid={setWsid}
              onCreateWorkspace={() => setShowCreateWorkspace(true)}
            />
          </div>

          {/* Workspace actions — only when one is selected */}
          {wsid && (
            <div className="border-t border-white/10 px-4 py-2">
              <button
                onClick={() => setShowWsMembers(true)}
                className="w-full text-left text-xs text-white/60 hover:text-white py-1"
              >
                👥 Members &amp; settings
              </button>
            </div>
          )}
        </div>

        {/* CHANNELS SIDEBAR */}
        <div className="w-56 bg-gray-200 flex flex-col overflow-hidden border-r">
          {/* ChannelList renders its own header + list */}
          <div className="flex-1 overflow-y-auto px-4 pt-4 pb-2">
            <ChannelList
              channels={channels}
              chid={chid}
              setChid={setChid}
              onCreateChannel={() => setShowCreateChannel(true)}
            />
            {/* Discover sits below the list, inside the same scroll area */}
            {wsid && (
              <button
                onClick={() => setShowDiscover(true)}
                className="mt-2 text-xs text-gray-400 hover:text-gray-700 flex items-center gap-1"
              >
                🔍 Browse public channels
              </button>
            )}
          </div>

          {/* Channel actions — only when one is selected */}
          {chid && (
            <div className="border-t border-gray-300 px-4 py-2">
              <button
                onClick={() => setShowChannelSettings(true)}
                className="w-full text-left text-xs text-gray-500 hover:text-gray-800 py-1"
              >
                ⚙️ Channel settings
              </button>
            </div>
          )}
        </div>

        {/* CHAT AREA */}
        <div className="flex-1 flex flex-col bg-white">
          <ChatWindow
            messages={messages}
            input={input}
            setInput={setInput}
            sendMessage={handleSend}
            chid={chid}
            user={user}
            channelName={currentChannelName}
            channelMembers={channelMembers}
          />
        </div>
      </div>

      {/* MODALS */}
      {showCreateWorkspace && (
        <CreateWorkspaceModal
          onClose={() => setShowCreateWorkspace(false)}
          onCreate={handleWorkspaceCreated}
        />
      )}

      {showCreateChannel && wsid && (
        <CreateChannelModal
          wsid={wsid}
          onClose={() => setShowCreateChannel(false)}
          onCreate={handleCreateChannel}
        />
      )}

      {showWsMembers && wsid && (
        <WorkspaceMembersModal
          wsid={wsid}
          currentUser={user}
          onClose={() => setShowWsMembers(false)}
          onLeft={handleLeftWorkspace}
          onDeleted={handleLeftWorkspace}
        />
      )}

      {showChannelSettings && chid && (
        <ChannelSettingsModal
          chid={chid}
          wsid={wsid}
          currentUser={user}
          onClose={() => setShowChannelSettings(false)}
          onDeleted={handleChannelGone}
          onLeft={handleChannelGone}
        />
      )}

      {showSearch && (
        <SearchModal
          onClose={() => setShowSearch(false)}
          onJumpTo={handleJumpTo}
        />
      )}

      {showDiscover && wsid && (
        <DiscoverChannelsModal
          wsid={wsid}
          onClose={() => setShowDiscover(false)}
          onJoined={() => fetchChannels(wsid).then(setChannels)}
        />
      )}

      {showSearch && (
        <SearchModal onClose={() => setShowSearch(false)} />
      )}
    </div>
  );
}

export default ChatPage;
