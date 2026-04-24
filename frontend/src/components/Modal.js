function Modal({ title, children, onClose }) {
  return (
    <div
      className="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50"
      onClick={onClose}
    >
      <div
        className="bg-white p-6 rounded shadow-lg w-96"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex justify-between items-center mb-4">
          <h2 className="font-semibold text-lg">{title}</h2>
          <button onClick={onClose} className="text-gray-500 hover:text-black">
            X
          </button>
        </div>

        {children}
      </div>
    </div>
  );
}

export default Modal;