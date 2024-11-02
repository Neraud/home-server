FROM python:3.13.0-alpine3.20

ARG caldav_recurring_task_scheduler_repo=Neraud/caldav-recurring-task-scheduler
ARG caldav_recurring_task_scheduler_version=0601e962a228aaa3610fefac9fde7f24caa9ce97

ENV CONFIG_PATH=/data/config.yaml
ENV LOG_LEVEL=INFO
ENV RUN_DATE=""
ENV RUN_USER ""
ENV DRY_RUN="N"

RUN adduser app -D

RUN mkdir -p /opt/caldav_recurring_task_scheduler && \
    wget -q -O- https://github.com/${caldav_recurring_task_scheduler_repo}/archive/${caldav_recurring_task_scheduler_version}.tar.gz  | tar xz --strip-components=1 -C /opt/caldav_recurring_task_scheduler && \
    chown -R app:app /opt/caldav_recurring_task_scheduler

RUN chmod +x /opt/caldav_recurring_task_scheduler/entrypoint.sh

USER app

RUN python3 -m pip install /opt/caldav_recurring_task_scheduler

ENTRYPOINT [ "/opt/caldav_recurring_task_scheduler/entrypoint.sh" ]
