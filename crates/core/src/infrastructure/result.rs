//! Global CoreResult Type Alias Specification

use super::errors::AppError;

pub type CoreResult<T> = Result<T, AppError>;
