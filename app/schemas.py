from datetime import datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict, Field


class TaskBase(BaseModel):
    title: str = Field(
        min_length=1,
        max_length=255,
        description="Short task title.",
        examples=["Buy groceries"],
    )
    description: Optional[str] = Field(
        default=None,
        description="Optional task details.",
        examples=["Milk, eggs, and bread"],
    )
    is_completed: bool = Field(
        default=False,
        description="Whether the task is completed.",
        examples=[False],
    )


class TaskCreate(TaskBase):
    pass


class TaskUpdate(BaseModel):
    title: Optional[str] = Field(
        default=None,
        min_length=1,
        max_length=255,
        description="Short task title.",
        examples=["Pay bills"],
    )
    description: Optional[str] = Field(
        default=None,
        description="Optional task details.",
        examples=["Electricity and internet"],
    )
    is_completed: Optional[bool] = Field(
        default=None,
        description="Whether the task is completed.",
        examples=[True],
    )


class TaskOut(TaskBase):
    id: int
    created_at: datetime = Field(
        description="Timestamp when the task was created.",
        examples=["2025-01-01T12:00:00Z"],
    )

    model_config = ConfigDict(from_attributes=True)
