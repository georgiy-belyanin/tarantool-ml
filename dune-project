(lang dune 3.17)

(name tarantool)

(generate_opam_files true)

(source
 (github georgiy-belyanin/tarantool-ml))

(authors "Georgiy Belyanin <belyaningeorge@ya.ru>")

(maintainers "Georgiy Belyanin <belyaningeorge@ya.ru>")

(license BSD-3-Clause)

(package
 (name tarantool)
 (synopsis "Tarantool client for OCaml")
 (description "Tarantool client for OCaml")
 (depends
  msgpck
  ocaml
  ppx_deriving
  ppx_protocol_conv
  ppx_protocol_conv_msgpack
  (ppx_expect :with-test)
  (ppx_inline_test :with-test)
  (ocamlformat
   (and
    (= 0.27.0)
    :dev))
  )
 (tags
  ("dbms" "tarantool" )))

(package
 (name tnt)
 (synopsis "Tarantool iproto library for OCaml")
 (description "Tarantool iproto library for OCaml")
 (depends
  ocaml
  ctypes
  ctypes-foreign
  ppx_deriving
  (ppx_expect :with-test)
  (ppx_inline_test :with-test)
  (ocamlformat
   (and
    (= 0.27.0)
    :dev))
  )
 (tags
  ("dbms" "tarantool" )))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html

