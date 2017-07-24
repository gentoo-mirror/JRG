(add-to-list 'load-path "@SITELISP@")
(autoload 'asn1-mode "asn1-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.asn1$" . asn1-mode))
(add-to-list 'auto-mode-alist '("\\.gdmo$" . asn1-mode))
