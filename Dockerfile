ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}

ARG MUTMUT_VERSION

WORKDIR /app

RUN pip install pytest mutmut==${MUTMUT_VERSION}

COPY src ./src
COPY tests ./tests
COPY pyproject.toml ./
COPY setup.cfg ./

CMD ["bash", "-c", "mutmut run"]
