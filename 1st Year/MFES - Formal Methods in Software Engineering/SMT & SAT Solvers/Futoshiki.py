from z3 import *
import math

example1 = """
   >   |   |
---+---+->-+---
   |   <   <
---+-<-+---+---
   |   |   |
---+---+->-+---
   |   |   |   

"""

example2 = """
   |   |   |
---+---+---+---
   >   |   |
---+---+---+---
   > 2 |   |
---+---+-<-+---
   |   |   |   
"""

example3 = """
         |     |     |
    -----+-----+-----+-----
         |     <     |
    -----+-----+-----+-----
         |     |  3  |
    -----+-----+-->--+----
         |     |     |   
"""

class Futoshiki_Board:

    def __init__(self, size, constraints, defaults, board=None):
        self.size = size
        self.constraints = constraints
        self.defaults = defaults
        self.board = board

    # Default cell length based on the matrix size
    def __default_cell_str_len(self):
        return max(3, int(math.log10(self.size)))

    # Returns a string of the value in the position *i* *j* of the board
    def __value_cell_str(self, i, j, cell_size=None):
        if cell_size is None:
            cell_size = self.__default_cell_str_len()
        cell = ''
        try:
            cell = str(self.defaults[i][j]).center(cell_size)
        except (KeyError, TypeError):
            try:
                cell = str(self.board[i][j]).center(cell_size)
            except (KeyError, TypeError):
                cell = ''.rjust(cell_size)
        return cell

    # Returns a string of the row separator between the position *[i][j]* and [i],[j+1]* of the board
    def __row_sep_cell_str(self, i, j, cell_size=None):
        if cell_size is None:
            cell_size = self.__default_cell_str_len()
        cell = ''
        try:
            cell += self.constraints['rows'][i][j].center(cell_size, '-')
        except (KeyError, TypeError):
            cell += ''.rjust(cell_size, '-')
        return cell

    # Returns a string corresponding to the current board
    def __str__(self):
        res = ""
        cell_size = self.__default_cell_str_len()

        for i in range(self.size):
            row_separator = ""
            for j in range(self.size):
                # Cell Value 
                res += self.__value_cell_str(i, j, cell_size)
                # Column division
                if j < self.size - 1:
                    try:
                        res += self.constraints['columns'][i][j]
                    except (TypeError, KeyError):
                        res += '|'
                # Row division 
                if i < self.size - 1:
                    row_separator += self.__row_sep_cell_str(i, j, cell_size)
                    if j < self.size - 1:
                        row_separator += '+'
            # Add row separator to final string
            res += '\n' + row_separator + '\n'
        return res

    # Converts a futoshiki board string into an Futoshiki_Board object
    @staticmethod
    def parse(string):
        # Clean Up useless chars and split the string into a list of lines
        lines = string.replace(' ', '').replace('-', '').strip().split('\n')

        # Split value rows from row separators
        values = lines[::2]
        row_seps = lines[1::2]
        # Matrix size corresponds to the number of value rows
        size = len(values)

        defaults = {}
        constraints = {'columns': {}, 'rows': {}}

        # Parse default values and column constraints
        for i in range(size):
            j = 0
            row = values[i].replace('>', '|>|').replace('<', '|<|').split('|')

            for token in row:
                if token == '>' or token == '<':
                    try:
                        constraints['columns'][i][j - 1] = token
                    except (KeyError, TypeError):
                        constraints['columns'][i] = {j - 1: token}
                else:
                    if token.isnumeric():
                        try:
                            defaults[i][j] = int(token)
                        except (KeyError, TypeError):
                            defaults[i] = {j: int(token)}
                    j += 1
        # Parse row separator constraints
        for i in range(len(row_seps)):
            row = row_seps[i].split('+')
            j = 0
            for cell in row:
                if cell == '>' or cell == '<':
                    try:
                        constraints['rows'][i][j] = cell
                    except (KeyError, TypeError):
                        constraints['rows'][i] = {j: cell}
                j += 1

        return Futoshiki_Board(size, constraints, defaults)


# Retorna uma expressão z3 corresponte á aplicação da operação *operation* á variaveis *t0* e *t1*
def cmp(t0, t1, operation):
    if operation == '>':
        return t0 > t1
    elif operation == '<':
        return t0 > t1


# Montagem do modelo do problema
def setup_futoshiki_model(fb, solver):
    # Inicialização do matriz das variaveis do tabuleiro
    board = [[Int(f'x{i}_{j}') for j in range(fb.size)] for i in range(fb.size)]

    # Restrições do valor das celulas
    for row in board:
        for var in row:
            solver.add(And(var >= 1, var <= fb.size))

    # Registo dos valores previamente definidos
    for i in fb.defaults:
        for j in fb.defaults[i]:
            solver.add(board[i][j] == fb.defaults[i][j])

    # Restrições sobre repetições na matriz
    for i in range(fb.size):
        # Cada elemento de uma linha é distinto
        solver.add(Distinct(board[i]))
        # Cada elemento de uma coluna é distinto
        solver.add(Distinct([row[i] for row in board]))

    # Restrições de grandeza entre as colunas
    for i, row in fb.constraints['columns'].items():
        for j, op in row.items():
            solver.add(cmp(board[i][j], board[i][j + 1], op))

    # Restrições de grandeza entre as linhas
    for i, row in fb.constraints['rows'].items():
        for j, op in row.items():
            solver.add(cmp(board[i][j], board[i + 1][j], op))

    return [solver, board, solver.check()]


# Resolução do problema
def futoshiki(fb):
    solver, board, validity = setup_futoshiki_model(fb, Solver())

    if validity == sat:
        m = solver.model()
        # Converção das matriz de variaveis em matriz de valores
        fb.board = list(map(lambda x: list(map(lambda y: m[y], x)), board))
    else:
        print('O tabuleiro é inválido ou não tem solução possivel.')

    return fb


b = Futoshiki_Board.parse(example3)
print(b.constraints)
print(b.defaults)

print(futoshiki(b))
