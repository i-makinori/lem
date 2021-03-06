(in-package :lem-language-client)

(defun do-log (fmt &rest args)
  (let* ((string (apply #'format nil fmt args))
         (buffer (lem:make-buffer "*jsonrpc-log*" :enable-undo-p nil))
         (p (lem:buffer-point buffer)))
    (lem:buffer-end p)
    (lem:insert-string p string)
    (lem:insert-character p #\newline)
    (dolist (window (lem:get-buffer-windows buffer))
      (lem:window-see window))))

(defun pretty-json (params)
  (with-output-to-string (stream)
    (yason:encode params (yason:make-json-output-stream stream))))

(defun jsonrpc-notify (connection method params)
  (do-log "notify: ~A ~A" method (pretty-json params))
  (jsonrpc:notify connection method params))

(defun jsonrpc-call (connection method params)
  (do-log "call: ~A ~A" method (pretty-json params))
  (jsonrpc:call connection method params))
