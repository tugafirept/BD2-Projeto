from django.db import connections
from pymongo import MongoClient
from django.conf import settings
from datetime import datetime
import uuid
from bson import Binary

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


def del_utilizador(id_utilizador):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL proc_delete_utilizador(%s);",
        [id_utilizador]
    )
    connections['default'].commit()
    cur.close()

def delete_event(event_id):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL proc_delete_evento(%s);",
        [event_id]
    )
    connections['default'].commit()
    cur.close()

def delete_palestrante(id_utilizador):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL proc_delete_palestrante(%s);",
        [id_utilizador]
    )
    connections['default'].commit()
    cur.close()

def delete_empresa(id_empresa):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL proc_delete_empresa(%s);",
        [id_empresa]
    )
    connections['default'].commit()
    cur.close()

def ins_evento(id_empresa, id_utilizador, nome, data, local, telefone, descricao, preco_inscricao, preco_total_evento):
    cur = connections['default'].cursor()
    
    cur.execute(
        """
        CALL insert_evento(%s, %s, %s, %s, %s, %s, %s, %s, %s);
        """,
        (id_empresa, id_utilizador, nome, data, local, telefone, descricao, preco_inscricao, preco_total_evento)
    )
    connections['default'].commit()
    cur.close()

def delete_inscricao(id_inscr):
    cur = connections['default'].cursor()
    cur.execute(
        "CALL proc_delete_inscricao(%s);",
        [id_inscr]
    )
    connections['default'].commit()
    cur.close()


## MONGO ----------------------

def get_mongo_client():
    client = MongoClient(settings.DATABASES['Mongo']['HOST'])
    db = client[settings.DATABASES['Mongo']['NAME']]  # Nome da base de dados
    return db

def save_comment(id_utilizador, id_evento, comentario):
    db = get_mongo_client()  # Assume que get_mongo_client retorna a conexão com o MongoDB
    comentarios_collection = db['comentarios']  # Nome da coleção

    # Gera um ID único para o comentário
    comentario_id = uuid.uuid4()

    comentario_id_binary = Binary.from_uuid(comentario_id)

    novo_comentario = {
        "id_comentario": comentario_id_binary, 
        "id_utilizador": id_utilizador,
        "id_evento": id_evento,
        "comentario": comentario,
        "data_comentario": datetime.now()
    }

    try:
        comentarios_collection.insert_one(novo_comentario)
        return comentario_id_binary  
    except Exception as e:
        print(f"Erro ao salvar comentário: {e}")
        return None
    
def save_rating(id_utilizador, id_evento, avaliacao):
    db = get_mongo_client()
    ratings_collection = db['avaliacoes']  # Nome da coleção de avaliações

    # Gera um ID único para a avaliação
    rating_id = uuid.uuid4()

    rating_id_binary = Binary.from_uuid(rating_id)

    nova_avaliacao = {
        "id_avaliacao": rating_id_binary,
        "id_utilizador": id_utilizador,
        "id_evento": id_evento,
        "avaliacao": avaliacao,
        "data_avaliacao": datetime.now()
    }

    try:
        ratings_collection.insert_one(nova_avaliacao)
        return rating_id_binary
    except Exception as e:
        print(f"Erro ao salvar avaliação: {e}")
        return None
    
def delete_comment(id_comentario):
    db = get_mongo_client() 
    comentarios_collection = db['comentarios'] 

    try:
        # Garantir que id_comentario seja do tipo UUID corretamente
        if isinstance(id_comentario, str):
            # Se o id_comentario for uma string UUID, converta para UUID
            comentario_uuid = uuid.UUID(id_comentario)
        else:
            # Caso contrário, assume-se que o id_comentario já é um UUID
            comentario_uuid = id_comentario

        # Converter o UUID para BSON Binary
        comentario_binary = Binary.from_uuid(comentario_uuid)

        # Tenta excluir o comentário com o id_comentario
        result = comentarios_collection.delete_one({"id_comentario": comentario_binary})

        if result.deleted_count == 1:  # Verifica se um comentário foi excluído
            print(f"Comentário com ID {id_comentario} excluído com sucesso.")
            return True
        else:
            print(f"Comentário com ID {id_comentario} não encontrado.")
            return False

    except Exception as e:
        print(f"Erro ao excluir comentário: {e}")
        return False