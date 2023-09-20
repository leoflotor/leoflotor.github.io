<!--
Add here global page variables to use throughout your website.
Directories must end with a "/".
-->
+++

author = "Flores-Torres Leonardo"
mintoclevel = 2

ignore = ["node_modules/"]

generate_rss = true
website_title = "QuantumBeans"
website_descr = "My journey on quantum mechanics, linear algebra, artificial intelligence, algorithms and programming languages."
website_url   = "https://leoflotor.github.io/"

+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}

<!--
Some tips to create custon environment commands:
https://franklinjl.org/demos/#franklin_demos

Command to easily add an image with its text aligned.
-->
\newcommand{\html}[1]{~~~#1~~~}
\newenvironment{center}{
  \html{<div style="text-align:center">}
}{
  \html{</div>}
}
\newenvironment{figure}[1]{
  \html{<figure>}
}{
  \begin{center}#1\end{center}\html{</figure>}
}
