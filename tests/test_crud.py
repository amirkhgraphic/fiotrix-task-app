def test_crud_create_get_update_delete(db_session):
    from app import crud, schemas

    created = crud.create_task(
        db_session,
        schemas.TaskCreate(title="First task", description="alpha", is_completed=False),
    )
    assert created.id is not None
    assert created.title == "First task"

    fetched = crud.get_task(db_session, created.id)
    assert fetched is not None
    assert fetched.title == "First task"

    updated = crud.update_task(
        db_session,
        fetched,
        schemas.TaskUpdate(title="Updated", is_completed=True),
    )
    assert updated.title == "Updated"
    assert updated.is_completed is True

    deleted = crud.delete_task(db_session, updated)
    assert deleted.id == created.id
    assert crud.get_task(db_session, created.id) is None


def test_crud_list_pagination(db_session):
    from app import crud, schemas

    for idx in range(3):
        crud.create_task(
            db_session,
            schemas.TaskCreate(title=f"Task {idx}", description=None, is_completed=False),
        )

    tasks = crud.get_tasks(db_session, skip=1, limit=1)
    assert len(tasks) == 1
    assert tasks[0].title == "Task 1"
