from django import forms

class RegistoForm(forms.Form):
    role_choices = [
        ('empresa', 'Empresa'),
        ('individual', 'Individual'),
    ]
    role = forms.ChoiceField(choices=role_choices, required=True, label="Registar como")
    name = forms.CharField(max_length=100, required=True, label="Nome")
    email = forms.EmailField(max_length=150, required=True, label="Email")
    password = forms.CharField(widget=forms.PasswordInput, max_length=100, required=True, label="Senha")
    birthdate = forms.DateField(required=False, label="Data de Nascimento")
    local = forms.CharField(max_length=200, required=False, label="Local")
    phone = forms.CharField(max_length=25, required=False, label="Telefone")
