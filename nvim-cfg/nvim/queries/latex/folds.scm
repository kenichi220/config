; Folds do LaTeX: só os títulos de seção.
;
; Substitui (não estende) o folds.scm do nvim-treesitter: o arquivo de queries
; em ~/.config/nvim vem antes no 'runtimepath' e, como não tem a modeline
; ";; extends", vira o base_query — o do plugin é descartado.
;
; O original também capturava (generic_environment), (math_environment),
; (displayed_equation), (block_comment) e (comment_environment). Era isso que
; retraía figure/table/itemize/equation e o próprio \begin{document}, que virava
; um fold de nível 0 engolindo o arquivo inteiro.
;
; Uma figura dentro de uma \section retraída continua escondida — ela faz parte
; do fold da seção — mas com a seção aberta ela fica sempre visível.
;
; Para voltar a retrair níveis mais fundos, é só acrescentar o nó à lista:
;   (chapter) (part) (subsubsection) (paragraph) (subparagraph)
[
  (section)
  (subsection)
] @fold
