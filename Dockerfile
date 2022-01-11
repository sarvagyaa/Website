FROM python:latest

ENV PYTHONUNBUFFERED 1

# Set the Django settings to use.
ENV DJANGO_ENV "dev"
ENV DJANGO_SETTINGS_MODULE "intro.settings.dev"

# Install a WSGI server into the container image.
RUN pip install waitress

# Code will end up living in /app/
WORKDIR /app/

# Create a "coderedcms" user account to run the appp.
RUN useradd coderedcms
RUN chown -R coderedcms /app/
USER coderedcms

# Copy our entrypoint script.
COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Finally, run the app on port 8000.
EXPOSE 8000
ENTRYPOINT ["docker-entrypoint.sh"]
CMD exec waitress serve --listen "*:8000" "intro.wsgi:application"
