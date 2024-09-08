FROM python:3.9-slim
WORKDIR /python-docker
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY . .
EXPOSE 5000
ENV FLASK_APP=app-deel.py
ARG db_user=""
ARG db_pass=""
ENV db_user=${db_user}
ENV db_pass=${db_pass}
CMD ["python", "-m", "app-deel", "run", "--host=0.0.0.0"]
