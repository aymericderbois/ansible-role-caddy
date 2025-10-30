# Ansible Role: Caddy

[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)

Rôle Ansible minimaliste pour installer et configurer [Caddy](https://caddyserver.com/) sur Debian 11/12/13.

## Fonctionnalités

- Installation de Caddy via APT depuis le dépôt officiel
- Gestion des configurations de sites via templates
- Support du DNS challenge pour Let's Encrypt (Cloudflare et autres)
- Validation automatique de la configuration
- Gestion du service systemd

## Plateformes supportées

- Debian 11 (Bullseye)
- Debian 12 (Bookworm)
- Debian 13 (Trixie)

## Utilisation

### Installation basique

```yaml
- hosts: servers
  become: true
  roles:
    - aymericderbois.caddy
  vars:
    caddy_acme_email: "admin@example.com"
```

### Avec DNS Challenge Cloudflare

La gestion des DNS challenges se fait directement via des variables Ansible que vous
pouvez définir et utiliser dans vos templates Jinja2.

Exemple pour Cloudflare:

```yaml
- hosts: servers
  become: true
  roles:
    - aymericderbois.caddy
  vars:
    caddy_acme_email: "admin@example.com"
    cloudflare_api_token: "your_cloudflare_api_token"
    caddy_sites_templates:
      - name: "example"
        template: "example-site.caddy.j2"
```

Template `example-site.caddy.j2`:
```jinja
example.com {
    tls {
        dns cloudflare {{ cloudflare_api_token }}
    }
    reverse_proxy localhost:8080
}
```

### Avec plusieurs sites

```yaml
- hosts: servers
  become: true
  roles:
    - aymericderbois.caddy
  vars:
    caddy_acme_email: "admin@example.com"
    caddy_sites_templates:
      - name: "site1"
        template: "site1.caddy.j2"
      - name: "site2"
        template: "site2.caddy.j2"
```

## Variables

### Variables principales

| Variable                | Défaut                     | Description                                           |
|-------------------------|----------------------------|-------------------------------------------------------|
| `caddy_config_dir`      | `/etc/caddy`               | Répertoire de configuration Caddy                     |
| `caddy_sites_dir`       | `/etc/caddy/sites-enabled` | Répertoire des configurations de sites                |
| `caddy_sites_templates` | `[]`                       | Liste des sites à configurer (voir format ci-dessous) |
| `caddy_acme_email`      | `""`                       | Email pour les certificats Let's Encrypt              |

### Format de `caddy_sites_templates`

```yaml
caddy_sites_templates:
  - name: "mon-site"           # Nom du fichier (sera: mon-site.caddy)
    template: "mon-site.caddy.j2"  # Template Jinja2 à utiliser
```

## Validation de la configuration

Le rôle valide automatiquement la configuration Caddy avant de recharger le service.
Si la validation échoue, le playbook s'arrêtera et Caddy ne sera pas reload.

## Tests


### Avec `make`

```bash
# Lancer les linters
make lint

# Lancer les tests Molecule (Debian 12)
make test

# Lancer les tests sur toutes les plateformes
make test-all
```

### Avec `uv`

```bash
uv run ansible-lint
uv run yamllint .
uv run molecule test
```

## Licence

MIT - [aymericderbois](https://github.com/aymericderbois)

## Auteur

Ce rôle a été créé par [aymericderbois](https://github.com/aymericderbois).
