ARG VERSION=latest
FROM developmentseed/geolambda:${VERSION}

LABEL maintainer="Matthew Hanson <matt.a.hanson@gmail.com>"

ARG PYVER=3.6.1

# install Python
ENV \
    PYENV_ROOT=/root/.pyenv \
    PATH=/root/.pyenv/shims:/root/.pyenv/bin:$PATH

RUN \
    echo PYVER ${PYVER}; \
    curl https://pyenv.run | bash; \
    pyenv install ${PYVER}; \
    pyenv global ${PYVER}; \
    pip install --upgrade pip

COPY requirements.txt ./

RUN \
    pip install -r requirements.txt