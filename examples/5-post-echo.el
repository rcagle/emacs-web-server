;;; post-echo.el --- echo back posted message using Emacs Web Server
(ws-start
 '(((:POST . ".*") .
    (lambda (request)
      (with-slots (process headers) request
        (let ((message (cdr (assoc "message" headers))))
          (ws-response-header process 200 '("Content-type" . "text/plain"))
          (process-send-string process
            (if message
                (format "you said %S\n" message)
              "This is a POST request, but it has no \"message\".\n"))))))
   ((:GET . ".*") .
    (lambda (request)
      (with-slots (process) request
        (ws-response-header process 200 '("Content-type" . "text/plain"))
        (process-send-string process
          "This is a GET request not a POST request.\n")))))
 9005)