# ===============================
# ARGUMENTOS DA IMAGEM
# ===============================
ARG PHP_VERSION=8.2-fpm
FROM php:${PHP_VERSION}

ARG APP_DIR=/var/www
ARG INSTALL_LEGACY_RUBY=false
ARG INSTALL_GHOSTSCRIPT_SRC=false

LABEL maintainer="StudyNotes"
LABEL description="PHP + Nginx + Supervisor - Template de estudo (legado opcional)"

# ===============================
# DEPENDÊNCIAS DE SISTEMA (layer única otimizada)
# ===============================
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    supervisor \
    samba \
    smbclient \
    nginx \
    curl \
    wget \
    git \
    unzip \
    build-essential \
    pkg-config \
    zlib1g-dev \
    libzip-dev \
    libpng-dev \
    libpq-dev \
    libxml2-dev \
    librabbitmq-dev \
    libssl-dev \
    libmagickwand-dev \
    imagemagick \
    xpdf \
    libjpeg-dev \
    libfreetype6-dev \
    libx11-dev \
    libxt-dev \
    libxext-dev \
    && rm -rf /var/lib/apt/lists/*

# ===============================
# GHOSTSCRIPT
# ===============================
# Por padrão usa ghostscript do apt (rápido). Só compila 9.54 se INSTALL_GHOSTSCRIPT_SRC=true
RUN if [ "$INSTALL_GHOSTSCRIPT_SRC" = "true" ]; then \
        cd /tmp && \
        wget -q https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9540/ghostscript-9.54.0.tar.gz && \
        tar -xzf ghostscript-9.54.0.tar.gz && \
        cd ghostscript-9.54.0 && \
        ./configure && make -j$(nproc) && make install && \
        cd / && rm -rf /tmp/ghostscript-9.54.0*; \
    else \
        echo "Usando ghostscript do apt (INSTALL_GHOSTSCRIPT_SRC=false)"; \
        gs --version || echo "ghostscript instalado via apt"; \
    fi

# ===============================
# RBENV + RUBY 1.9.3 (LEGADO - OPCIONAL)
# ===============================
# AVISO: Ruby 1.9.3 é EOL desde 2015, com CVEs conhecidas. Só ative se realmente precisa do DokViewerGestor legado.
# Build isolado para não penalizar quem não usa: docker build --build-arg INSTALL_LEGACY_RUBY=true
RUN if [ "$INSTALL_LEGACY_RUBY" = "true" ]; then \
        apt-get update && apt-get install -y --no-install-recommends \
            libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libdb-dev bison libyaml-dev autoconf \
        && rm -rf /var/lib/apt/lists/* \
        && export RBENV_ROOT="/root/.rbenv" && export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH" \
        && git clone https://github.com/rbenv/rbenv.git $RBENV_ROOT \
        && git clone https://github.com/rbenv/ruby-build.git $RBENV_ROOT/plugins/ruby-build \
        && $RBENV_ROOT/plugins/ruby-build/install.sh \
        && rbenv install 1.9.3-p551 && rbenv global 1.9.3-p551 \
        && ln -sf $RBENV_ROOT/shims/ruby /usr/local/bin/ruby \
        && ln -sf $RBENV_ROOT/shims/gem /usr/local/bin/gem \
        && ruby -v \
        && gem install tilt -v 1.3.7 --no-ri --no-rdoc \
        && gem install sinatra -v 1.4.7 --no-ri --no-rdoc \
        && gem install haml -v 4.0.7 --no-ri --no-rdoc; \
    else \
        echo "Pulando Ruby 1.9.3 legado (INSTALL_LEGACY_RUBY=false). Ative com --build-arg INSTALL_LEGACY_RUBY=true"; \
    fi
ENV RBENV_ROOT="/root/.rbenv"
ENV PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"

# ===============================
# SUPERVISOR E NGINX (com fallback se arquivos não existirem)
# ===============================
# Cria estrutura mínima para não quebrar se o usuário não tiver ./docker
RUN mkdir -p /etc/supervisord.d /etc/nginx/sites-available /etc/ImageMagick-6
COPY ./docker/supervisord/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./docker/supervisord/conf/ /etc/supervisord.d/
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/sites/ /etc/nginx/sites-available/
COPY ./docker/imagemagick/policy.xml /etc/ImageMagick-6/policy.xml

# ===============================
# EXTENSÕES PHP
# ===============================
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        sockets \
        mysqli \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        session \
        xml \
        zip \
        iconv \
        simplexml \
        pcntl \
        gd \
        fileinfo

RUN pecl install amqp && docker-php-ext-enable amqp
RUN pecl install imagick && docker-php-ext-enable imagick

# ===============================
# COMPOSER
# ===============================
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# ===============================
# PHP INI
# ===============================
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# ===============================
# CONFIGURAÇÕES DE PROJETO
# ===============================
WORKDIR ${APP_DIR}
RUN mkdir -p ${APP_DIR} && chown -R www-data:www-data ${APP_DIR}

# COPY condicional: só copia se existir (evita quebra quando repo é só documentação)
# O .dockerignore deve ignorar applications se não existir
COPY ./applications* ${APP_DIR}/
COPY ./setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh \
    && chown -R www-data:www-data ${APP_DIR} || true

# Imagemagick policy já copiada acima, garante permissão
RUN chown -R www-data:www-data ${APP_DIR} || true

# ===============================
# HEALTHCHECK
# ===============================
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost/ || nginx -t || exit 1

# ===============================
# CMD (runtime)
# ===============================
CMD ["/bin/bash", "-c", "/usr/local/bin/setup.sh && exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf"]
