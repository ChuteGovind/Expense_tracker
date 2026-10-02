package com.govind.expensetracker.dto;
import com.govind.expensetracker.entity.TransactionType;
import jakarta.validation.constraints.*;
import java.math.BigDecimal; import java.time.LocalDate;
public record TransactionRequest(@NotNull TransactionType type,@NotBlank @Size(max=80) String category,@NotBlank @Size(max=120) String title,@NotNull @DecimalMin("0.01") BigDecimal amount,@NotNull LocalDate transactionDate,@Size(max=500) String note) {}
