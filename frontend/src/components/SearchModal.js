import { useState, useRef, useEffect } from "react";
import Modal from "./Modal";
import { searchMessages } from "../services/api";

function highlight(text, query) {
  if (!query) return text;
  const parts = text.split(new RegExp(`(${query})`, "gi"));
  return parts.map((part, i) =>
    part.toLowerCase() === query.toLowerCase()
      ? <mark key={i} className="bg-yellow-200 rounded px-0.5">{part}</mark>
      : part
  );
}

function SearchModal({ onClose, onJumpTo }) {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const inputRef = useRef(null);

  useEffect(() => {
    inputRef.current?.focus();
  }, []);

  const handleSearch = async () => {
    const trimmed = query.trim();
    if (!trimmed) return;
    setLoading(true);
    setSearched(false);
    try {
      const data = await searchMessages(trimmed);
      setResults(data || []);
    } catch (e) {
      setResults([]);
    } finally {
      setLoading(false);
      setSearched(true);
    }
  };

  const handleKeyDown = (e) => {
    if (e.key === "Enter") handleSearch();
  };

  const handleJump = (result) => {
    onJumpTo(result.wsid, result.chid);
    onClose();
  };

  const formatDate = (iso) => {
    if (!iso) return "";
    const d = new Date(iso);
    return d.toLocaleDateString(undefined, { month: "short", day: "numeric" }) +
      " at " + d.toLocaleTimeString(undefined, { hour: "numeric", minute: "2-digit" });
  };

  return (
    <Modal title="Search Messages" onClose={onClose}>
      {/* Search input */}
      <div className="flex gap-2 mb-4">
        <input
          ref={inputRef}
          placeholder="Search for keywords in messages..."
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          onKeyDown={handleKeyDown}
          className="flex-1 p-2 border rounded text-sm"
        />
        <button
          onClick={handleSearch}
          disabled={loading || !query.trim()}
          className="px-4 py-2 bg-[#240057] text-white rounded text-sm disabled:opacity-50"
        >
          {loading ? "..." : "Search"}
        </button>
      </div>

      {/* Results */}
      {searched && results.length === 0 && (
        <p className="text-sm text-gray-500 text-center py-6">
          No messages found for "{query}"
        </p>
      )}

      {results.length > 0 && (
        <>
          <p className="text-xs text-gray-400 mb-2">
            {results.length} result{results.length !== 1 ? "s" : ""} — click to jump to channel
          </p>
          <div className="max-h-96 overflow-y-auto divide-y border rounded">
            {results.map((r) => (
              <div
                key={r.msgid}
                onClick={() => handleJump(r)}
                className="px-3 py-3 hover:bg-purple-50 cursor-pointer group"
              >
                {/* Channel + workspace breadcrumb */}
                <div className="flex items-center gap-1 text-xs text-gray-400 mb-1">
                  <span className="font-medium text-[#240057]">#{r.chname}</span>
                  <span>·</span>
                  <span>{r.wsname}</span>
                  <span className="ml-auto text-gray-300 group-hover:text-[#240057] text-xs">
                    Jump →
                  </span>
                </div>
                {/* Message content with highlight */}
                <p className="text-sm text-gray-800 leading-snug mb-1">
                  {highlight(r.content, query.trim())}
                </p>
                {/* Author + timestamp */}
                <div className="text-xs text-gray-400">
                  {r.author} · {formatDate(r.postat)}
                </div>
              </div>
            ))}
          </div>
        </>
      )}
    </Modal>
  );
}

export default SearchModal;
