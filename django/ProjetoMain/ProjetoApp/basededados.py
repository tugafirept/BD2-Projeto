from django.db import connections

def ins_empresa(name, email, password, local=None, telefone=None):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL insert_empresa(%s, %s, %s, %s, %s);",
        (name, email, password, local, telefone)
    )
    connections['default'].commit()
    cur.close()

def ins_utilizador(name, email, password, data_nascimento=None):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL insert_utilizador(%s, %s, %s, %s);",
        (name, email, password, data_nascimento)
    )
    connections['default'].commit()
    cur.close()
