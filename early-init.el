;; Disable package-quickstart
(setq package-quickstart nil)

;; Using straight.el
(setq package-enable-at-startup nil)

;; ---- Startup Performance ----
;; Make startup faster by reducing the frequency of GC and the use
;;  a hook to measure Emacs startup time.
;; The default is 800KB. Mesured in bytes.
;; GC off during init. (focus all memory on init)
(setq gc-cons-threshold (* 50 1000 1000)
      gc-cons-percentage 0.6)


;; Ignore X resources. It's settings would be redundant with the other
;;  settings in this file and can conflict with later config
;;  (particularly where the cursor color is concerned).
(advice-add #'x-apply-session-resources :override #'ignore)

;; Inhibite resizing emacs frame
(setq frame-inhibit-implied-resize t)

;; Emacs memory management
(setq read-process-output-max (* 1024 1024)) ; 1MB instead of 4KB
