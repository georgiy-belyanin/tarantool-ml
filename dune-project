(lang dune 3.17)

(name tarantool_ml)

(generate_opam_files true)

(source
 (github georgiy-belyanin/tarantool-ml))

(authors "Georgiy Belyanin <belyaningeorge@ya.ru>")

(maintainers "Georgiy Belyanin <belyaningeorge@ya.ru>")

(license BSD-3-Clause)

(package
 (name tarantool_ml)
 (synopsis "Tarantool client for OCaml")
 (description "Tarantool client for OCaml")
 (depends ocaml)
 (tags
  ("dbms" "tarantool" )))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
