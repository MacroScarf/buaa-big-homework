# coding=utf-8
import jsonpickle


def getSessionInfo(request):
    suser = request.session.get('user', '')

    if suser:
        try:
            user = jsonpickle.loads(suser)
            return {'user': user}
        except TypeError as e:
            print(f"Error decoding JSON: {e}")
            return {'user': ''}
    return {'user': ''}
