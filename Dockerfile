FROM minicli/php81-dev:latest AS builder

COPY . /home/minicli/
RUN cd /home/minicli && \
    composer install --no-progress --no-dev --prefer-dist

FROM minicli/php81:latest
COPY --from=builder /home/minicli /home/minicli

ENTRYPOINT [ "php81", "/home/minicli/minicli" ]
CMD ["update-contributors"]
