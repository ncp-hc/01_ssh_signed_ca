Vault 상에 Singed SSH 구성과 Target Host 구성


다음 링크 상에 있는 메뉴얼을 참고하여 작업.
https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates

이 중 Client Key Signing을 구성하는 과정을 수작업이 아닌 Terraform을 통해 작업하고, Client Authentication 과정은 Script로 수행.


# Vault를 사용한 SSH CA 사용 사례

이 시나리오에서는 내부 CA를 사용하여 SSH 키에 서명하도록 Vault를 설정합니다. SSH Secret 엔진을 구성하고 Vault 내에 CA를 생성합니다. 
그런 다음 방금 만든 CA 키를 신뢰하도록 SSH 서버를 구성합니다. 마지막으로 개인 키와 Vault SSH CA에서 서명 한 공개 키를 사용하여 SSH를 시도합니다.
