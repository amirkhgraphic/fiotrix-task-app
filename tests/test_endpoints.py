def test_create_list_get_update_delete(client):
    response = client.post(
        "/tasks/",
        json={"title": "API task", "description": "desc", "is_completed": False},
    )
    assert response.status_code == 201
    task = response.json()
    task_id = task["id"]
    assert task["title"] == "API task"

    response = client.get("/tasks/")
    assert response.status_code == 200
    assert len(response.json()) == 1

    response = client.get(f"/tasks/{task_id}")
    assert response.status_code == 200
    assert response.json()["id"] == task_id

    response = client.put(
        f"/tasks/{task_id}",
        json={"title": "Updated task", "is_completed": True},
    )
    assert response.status_code == 200
    assert response.json()["title"] == "Updated task"

    response = client.delete(f"/tasks/{task_id}")
    assert response.status_code == 200

    response = client.get(f"/tasks/{task_id}")
    assert response.status_code == 404


def test_get_missing_task_returns_404(client):
    response = client.get("/tasks/9999")
    assert response.status_code == 404
