module Language.Lambda.Parser (parseExpr) where

import Control.Monad
import Prelude hiding (abs, curry)

import Text.Parsec
import Text.Parsec.String

import Language.Lambda.Expression

parseExpr :: String -> Either ParseError (LambdaExpr String)
parseExpr = parse (whitespace *> expr <* eof) ""

expr :: Parser (LambdaExpr String)
expr = try app <|> term

term :: Parser (LambdaExpr String)
term = let' <|> abs <|> var <|> parens <|> numeral <|> plus <|> mult

var :: Parser (LambdaExpr String)
var = Var <$> identifier

abs :: Parser (LambdaExpr String)
abs = curry <$> idents <*> expr
  where idents = symbol '\\' *> many1 identifier <* symbol '.'
        curry = flip (foldr Abs)

app :: Parser (LambdaExpr String)
app = chainl1 term (return App)

let' :: Parser (LambdaExpr String)
let' = Let <$> ident <*> expr
  where ident = keyword "let" *> identifier <* symbol '='

parens :: Parser (LambdaExpr String)
parens = symbol '(' *> expr <* symbol ')'

lexeme :: Parser a -> Parser a
lexeme p =  p <* whitespace

whitespace :: Parser ()
whitespace = void . many . oneOf $ " \t"

identifier :: Parser String
identifier = lexeme ((:) <$> first <*> many rest)
  where first = letter <|> char '_'
        rest  = first <|> digit

symbol :: Char -> Parser ()
symbol = void . lexeme . char

keyword :: String -> Parser ()
keyword = void . lexeme . string

numeral :: Parser (LambdaExpr String)
numeral = church <$> lexeme digit
    where
        church '0' = Abs "f" (Abs "x" (Var "x"))
        church '1' = Abs "f" (Abs "x" (App (Var "f") (Var "x")))
        church n = Abs "f" (Abs "x" (foldr (App) (Var "x") (replicate (read [n]) (Var "f"))))

plus :: Parser (LambdaExpr String)
plus = plus' <$> lexeme (char '+')
    where plus' _ = Abs "m" (Abs "n" (Abs "f" (Abs "x" ( App (App (Var "m") (Var "f")) (App (App (Var "n") (Var "f")) (Var "x"))))))

mult :: Parser (LambdaExpr String)
mult = mult' <$> lexeme (char '*')
    where mult' _ = Abs "m" (Abs "n" (Abs "f" (Abs "x" (App (App (Var "m") (App (Var "n") (Var "f"))) (Var "x")))))

