(loop for (a . b) in '((eating . icecream) (coding . lisp))
       do (format t "still ~(~a~) the ~(~a~)?~%" a b))
